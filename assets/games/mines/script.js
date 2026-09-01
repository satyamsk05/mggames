(function() {
  // --- WALLET STATE ---
  let balance = 150.57;
  let betAmount = 10.00;
  let isPlaying = false;
  let revealed = 0;
  let minePositions = new Set();
  let tileStates = []; // 'hidden' | 'gem' | 'mine'
  const GRID = 25;

  // Stats
  let wins = 0;
  let losses = 0;
  let totalProfit = 0;

  // --- AUDIO SYNTHESISER ---
  class SoundManager {
    constructor() {
      this.ctx = null;
      this.muted = false;
    }
    init() {
      if (!this.ctx) {
        this.ctx = new (window.AudioContext || window.webkitAudioContext)();
      }
    }
    toggleMute() {
      this.muted = !this.muted;
      return this.muted;
    }
    playClick() {
      if (this.muted) return;
      this.init();
      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      osc.connect(gain);
      gain.connect(this.ctx.destination);
      osc.frequency.setValueAtTime(400, this.ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(150, this.ctx.currentTime + 0.05);
      gain.gain.setValueAtTime(0.08, this.ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.05);
      osc.start();
      osc.stop(this.ctx.currentTime + 0.05);
    }
    playSafe() {
      if (this.muted) return;
      this.init();
      const now = this.ctx.currentTime;
      const playTone = (freq, start, duration) => {
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.type = 'triangle';
        osc.connect(gain);
        gain.connect(this.ctx.destination);
        osc.frequency.setValueAtTime(freq, start);
        osc.frequency.exponentialRampToValueAtTime(freq * 1.5, start + duration);
        gain.gain.setValueAtTime(0.12, start);
        gain.gain.exponentialRampToValueAtTime(0.001, start + duration);
        osc.start(start);
        osc.stop(start + duration);
      };
      playTone(523.25, now, 0.15); // C5
      playTone(783.99, now + 0.08, 0.25); // G5
    }
    playMine() {
      if (this.muted) return;
      this.init();
      const now = this.ctx.currentTime;
      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      osc.type = 'sawtooth';
      osc.connect(gain);
      gain.connect(this.ctx.destination);
      osc.frequency.setValueAtTime(120, now);
      osc.frequency.linearRampToValueAtTime(30, now + 0.5);
      gain.gain.setValueAtTime(0.25, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.5);
      osc.start();
      osc.stop(now + 0.5);
    }
    playCashout() {
      if (this.muted) return;
      this.init();
      const now = this.ctx.currentTime;
      for (let i = 0; i < 4; i++) {
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.type = 'sine';
        osc.connect(gain);
        gain.connect(this.ctx.destination);
        const freq = 660 + (i * 150);
        osc.frequency.setValueAtTime(freq, now + i * 0.06);
        gain.gain.setValueAtTime(0.1, now + i * 0.06);
        gain.gain.exponentialRampToValueAtTime(0.001, now + i * 0.06 + 0.15);
        osc.start(now + i * 0.06);
        osc.stop(now + i * 0.06 + 0.15);
      }
    }
  }

  const sound = new SoundManager();

  // --- FLUTTER COMMUNICATOR ---
  const urlParams = new URLSearchParams(window.location.search);
  const urlBalance = parseFloat(urlParams.get('balance'));
  if (!isNaN(urlBalance)) balance = urlBalance;

  window.setBalanceFromFlutter = function(newBal) {
    balance = parseFloat(newBal);
    updateUI();
  };

  function sendToFlutter(type, data = {}) {
    const payload = JSON.stringify({ type, ...data });
    if (window.parent && window.parent !== window) {
      window.parent.postMessage(payload, '*');
    }
    if (window.opener) {
      window.opener.postMessage(payload, '*');
    }
    if (window.FlutterBridge) {
      window.FlutterBridge.postMessage(payload);
    }
  }

  // --- SVG ASSET BUILDERS ---
  const SVG_GEM = `
    <svg viewBox="0 0 64 64" width="100%" height="100%">
      <defs>
        <linearGradient id="gemGrad" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#d8b4fe" />
          <stop offset="50%" stop-color="#8b5cf6" />
          <stop offset="100%" stop-color="#5b21b6" />
        </linearGradient>
        <filter id="glow">
          <feGaussianBlur stdDeviation="1" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>
      <polygon points="32,8 54,24 44,56 20,56 10,24" fill="url(#gemGrad)" />
      <polygon points="32,8 32,56 44,56 54,24" fill="rgba(255,255,255,0.15)"/>
      <polygon points="32,8 20,56 10,24" fill="rgba(0,0,0,0.15)"/>
      <polygon points="32,24 44,24 32,48 20,24" fill="rgba(255,255,255,0.25)"/>
      <path d="M18,22 Q22,22 22,18 Q22,22 26,22 Q22,22 22,26 Q22,22 18,22 Z" fill="#ffffff" filter="url(#glow)"/>
      <path d="M42,42 Q46,42 46,38 Q46,42 50,42 Q46,42 46,46 Q46,42 42,42 Z" fill="#ffffff" filter="url(#glow)"/>
    </svg>
  `;

  const SVG_MINE = `
    <svg viewBox="0 0 64 64" width="100%" height="100%">
      <defs>
        <radialGradient id="bombGrad" cx="35%" cy="35%" r="65%">
          <stop offset="0%" stop-color="#555555" />
          <stop offset="100%" stop-color="#111111" />
        </radialGradient>
        <radialGradient id="sparkGrad" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stop-color="#fffb76" />
          <stop offset="100%" stop-color="#ff9900" />
        </radialGradient>
      </defs>
      <path d="M38,20 Q48,12 44,6" fill="none" stroke="#e2e8f0" stroke-width="2.5" stroke-linecap="round"/>
      <circle cx="44" cy="6" r="4.5" fill="url(#sparkGrad)"/>
      <path d="M44,1 L46,5 L50,6 L46,7 L44,11 L42,7 L38,6 L42,5 Z" fill="#fffb76" />
      <circle cx="32" cy="36" r="18" fill="url(#bombGrad)" stroke="#222" stroke-width="1"/>
      <circle cx="25" cy="29" r="4" fill="rgba(255,255,255,0.15)"/>
      <rect x="28" y="20" width="8" height="4" rx="1" fill="#333"/>
      <ellipse cx="32" cy="34" rx="6" ry="5.5" fill="#e2e8f0"/>
      <rect x="29" y="38" width="6" height="3" rx="1" fill="#e2e8f0"/>
      <circle cx="30" cy="34" r="1.5" fill="#111"/>
      <circle cx="34" cy="34" r="1.5" fill="#111"/>
      <polygon points="32,35.5 31,37 33,37" fill="#111"/>
      <line x1="31" y1="39" x2="31" y2="41" stroke="#111" stroke-width="0.8"/>
      <line x1="32" y1="39" x2="32" y2="41" stroke="#111" stroke-width="0.8"/>
      <line x1="33" y1="39" x2="33" y2="41" stroke="#111" stroke-width="0.8"/>
    </svg>
  `;

  // DOM elements
  const headerBalance = document.getElementById('headerBalance');
  const btnMute = document.getElementById('btnMute');
  const speakerIcon = document.getElementById('speakerIcon');
  const btnBack = document.getElementById('btnBack');
  const multipliersWrapper = document.getElementById('multipliersWrapper');
  const board = document.getElementById('board');
  const betInput = document.getElementById('betInput');
  const btnHalf = document.getElementById('btnHalf');
  const btnDouble = document.getElementById('btnDouble');
  const minesSelect = document.getElementById('minesSelect');
  const minesValMin = document.getElementById('minesValMin');
  const btnRandom = document.getElementById('btnRandom');
  const btnBet = document.getElementById('btnBet');
  const statusText = document.getElementById('statusText');
  const statProfit = document.getElementById('statProfit');
  const statWins = document.getElementById('statWins');
  const statLosses = document.getElementById('statLosses');

  // --- MULTIPLIERS CALCULATION & BET WIN HISTORY ---
  function getMultiplier(mines, revealedCount) {
    if (revealedCount === 0) return 1.00;
    let mult = 1.0;
    for (let i = 0; i < revealedCount; i++) {
      mult *= (25 - i) / (25 - mines - i);
    }
    return parseFloat((mult * 0.99).toFixed(2));
  }

  let historyMultipliers = [1.13, 1.29, 1.48, 1.71, 2.00]; // Recent bet history

  function updateMultipliersRoad() {
    if (!multipliersWrapper) return;
    multipliersWrapper.innerHTML = '';
    
    // Render past bet win history badges
    historyMultipliers.slice(-8).forEach(multVal => {
      const badge = document.createElement('div');
      badge.className = 'multiplier-badge';
      badge.textContent = `${parseFloat(multVal).toFixed(2)}x`;
      multipliersWrapper.appendChild(badge);
    });
  }

  // --- UI UPDATE UTILS ---
  function updateUI() {
    if (headerBalance) headerBalance.textContent = `${balance.toFixed(2)}`;
    if (statProfit) statProfit.textContent = `₹${totalProfit >= 0 ? '+' : ''}${totalProfit.toFixed(2)}`;
    if (statWins) statWins.textContent = wins;
    if (statLosses) statLosses.textContent = losses;
  }

  // --- GAMEPLAY LOGIC ---
  function initBoard() {
    if (!board) return;
    tileStates = Array(GRID).fill('hidden');
    
    let tiles = board.querySelectorAll('.tile');
    if (tiles.length === 0) {
      board.innerHTML = '';
      for (let i = 0; i < GRID; i++) {
        const tile = document.createElement('button');
        tile.type = 'button';
        tile.className = 'tile';
        tile.dataset.index = i;
        board.appendChild(tile);
      }
      tiles = board.querySelectorAll('.tile');
    }

    tiles.forEach((tile, i) => {
      tile.className = 'tile';
      tile.innerHTML = '';
      tile.dataset.index = i;
      const newTile = tile.cloneNode(true);
      if (tile.parentNode) tile.parentNode.replaceChild(newTile, tile);
      newTile.addEventListener('click', () => handleTileClick(i, newTile));
    });

    updateMultipliersRoad();
  }

  function generateMines(excludeIndex) {
    minePositions.clear();
    const count = parseInt(minesSelect.value);
    while (minePositions.size < count) {
      const pos = Math.floor(Math.random() * GRID);
      if (pos !== excludeIndex) {
        minePositions.add(pos);
      }
    }
  }

  function handleTileClick(index, tileElement) {
    // PREVENT TILE OPENING BEFORE BETTING!
    if (!isPlaying) {
      sound.playClick();
      if (statusText) {
        statusText.textContent = 'Please click BET to start playing!';
        statusText.style.color = '#f59e0b';
        setTimeout(() => {
          if (!isPlaying && statusText) {
            statusText.textContent = 'Set bet amount and click Bet';
            statusText.style.color = '#949ea8';
          }
        }, 1500);
      }
      return; // DO NOT REVEAL TILE WITHOUT BET
    }

    if (tileStates[index] !== 'hidden') return;
    
    sound.playClick();
    revealed++;
    
    // Check hit
    if (minePositions.has(index)) {
      // Hit a mine!
      tileStates[index] = 'mine';
      revealMine(index, tileElement);
      endRound(false);
    } else {
      // Safe tile
      tileStates[index] = 'gem';
      revealGem(index, tileElement);
      
      const currentMines = parseInt(minesSelect.value);
      const nextMult = getMultiplier(currentMines, revealed);
      const winAmount = betAmount * nextMult;
      
      if (btnBet) {
        btnBet.textContent = `Cash out ₹${winAmount.toFixed(2)}`;
        btnBet.className = 'btn-main btn-bet cashout';
      }
      if (statusText) {
        statusText.textContent = `Safe! Payout now: ${nextMult}x`;
        statusText.style.color = '#949ea8';
      }
      
      sound.playSafe();
      createSuccessParticles(tileElement);
      showFloatingText(tileElement, `+${nextMult}x`);
      
      updateMultipliersRoad();
    }
  }

  function revealGem(index, tileElement) {
    tileElement.classList.add('revealed', 'safe');
    tileElement.innerHTML = SVG_GEM;
  }

  function revealMine(index, tileElement) {
    tileElement.classList.add('revealed', 'mine');
    tileElement.innerHTML = SVG_MINE;
  }

  function startRound(firstClickIndex = -1) {
    // Read amounts
    betAmount = parseFloat(betInput.value);
    if (isNaN(betAmount) || betAmount <= 0) {
      alert('Please enter a valid bet amount');
      return;
    }
    
    if (betAmount > balance) {
      alert('Insufficient Balance');
      return;
    }

    // Deduct bet
    balance -= betAmount;
    sendToFlutter('updateBalance', { balance: balance });
    updateUI();

    isPlaying = true;
    revealed = 0;
    
    // Generate mines
    generateMines(firstClickIndex);

    // Lock options
    if (betInput) betInput.disabled = true;
    if (minesSelect) minesSelect.disabled = true;
    if (btnHalf) btnHalf.disabled = true;
    if (btnDouble) btnDouble.disabled = true;
    
    if (btnBet) {
      btnBet.textContent = 'Cash out ₹0.00';
      btnBet.className = 'btn-main btn-bet cashout';
    }
    if (btnRandom) btnRandom.style.display = 'block';
    if (statusText) statusText.textContent = 'Clear the gems and avoid the mines!';
  }

  function endRound(isWin) {
    isPlaying = false;
    
    // Re-enable controls
    if (betInput) betInput.disabled = false;
    if (minesSelect) minesSelect.disabled = false;
    if (btnHalf) btnHalf.disabled = false;
    if (btnDouble) btnDouble.disabled = false;
    
    if (btnBet) {
      btnBet.textContent = 'Bet';
      btnBet.className = 'btn-main btn-bet';
    }
    if (btnRandom) btnRandom.style.display = 'none';

    const currentMines = parseInt(minesSelect.value);

    if (isWin) {
      const payoutMult = getMultiplier(currentMines, revealed);
      const winnings = betAmount * payoutMult;
      const profit = winnings - betAmount;
      
      balance += winnings;
      totalProfit += profit;
      wins++;
      
      // Push won multiplier to recent bet history
      historyMultipliers.push(payoutMult);
      if (historyMultipliers.length > 12) historyMultipliers.shift();
      updateMultipliersRoad();
      
      if (statusText) statusText.textContent = `Won ₹${winnings.toFixed(2)} (${payoutMult}x)!`;
      sound.playCashout();
      sendToFlutter('updateBalance', { balance: balance });
      showWinNotification(winnings, payoutMult);
    } else {
      losses++;
      totalProfit -= betAmount;
      if (statusText) statusText.textContent = 'Boom! You hit a mine.';
      sound.playMine();
      triggerScreenShake();
    }

    // Reveal all remaining hidden tiles as faded/dimmed
    if (board) {
      for (let i = 0; i < GRID; i++) {
        if (tileStates[i] === 'hidden') {
          const el = board.children[i];
          if (el) {
            el.classList.add('auto-revealed');
            if (minePositions.has(i)) {
              tileStates[i] = 'mine';
              revealMine(i, el);
            } else {
              tileStates[i] = 'gem';
              revealGem(i, el);
            }
          }
        }
      }
    }

    updateUI();
    
    // Reset revealed counter
    revealed = 0;
    updateMultipliersRoad();
  }

  function showWinNotification(amount, multiplier) {
    let overlay = document.getElementById('win-popup-overlay');
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.id = 'win-popup-overlay';
      overlay.style.cssText = `
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.45);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 99999;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.3s ease;
      `;
      
      const card = document.createElement('div');
      card.style.cssText = `
        background: #2b3536;
        border: 2px solid #3d4748;
        border-radius: 16px;
        padding: 20px 32px;
        display: flex;
        flex-direction: column;
        align-items: center;
        box-shadow: 0 10px 25px rgba(0,0,0,0.5);
        min-width: 220px;
        transform: scale(0.9);
        transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      `;
      
      const multRow = document.createElement('div');
      multRow.style.cssText = `
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        color: #20e18d;
        font-size: 26px;
        font-weight: 900;
        text-shadow: 0 0 10px rgba(32, 225, 141, 0.25);
      `;
      
      const star1 = document.createElement('span');
      star1.innerHTML = '✦';
      star1.style.cssText = 'font-size: 18px; opacity: 0.8; margin-bottom: 2px;';
      
      const multText = document.createElement('span');
      multText.id = 'win-popup-multiplier';
      
      const star2 = document.createElement('span');
      star2.innerHTML = '✦';
      star2.style.cssText = 'font-size: 18px; opacity: 0.8; margin-bottom: 2px;';
      
      multRow.appendChild(star1);
      multRow.appendChild(multText);
      multRow.appendChild(star2);
      
      const pill = document.createElement('div');
      pill.style.cssText = `
        background: #202526;
        border-radius: 20px;
        padding: 6px 16px;
        margin-top: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
        justify-content: center;
      `;
      
      const amtText = document.createElement('span');
      amtText.id = 'win-popup-amount';
      amtText.style.cssText = 'color: #fff; font-size: 15px; font-weight: 800;';
      
      const rcoin = document.createElement('span');
      rcoin.textContent = '₹';
      rcoin.style.cssText = `
        width: 18px;
        height: 18px;
        border-radius: 50%;
        background: #e86d22;
        display: inline-grid;
        place-items: center;
        font-size: 10px;
        font-weight: 900;
        color: #fff;
      `;
      
      pill.appendChild(amtText);
      pill.appendChild(rcoin);
      
      card.appendChild(multRow);
      card.appendChild(pill);
      overlay.appendChild(card);
      document.body.appendChild(overlay);
    }
    
    const popupMult = document.getElementById('win-popup-multiplier');
    const popupAmt = document.getElementById('win-popup-amount');
    if (popupMult) popupMult.textContent = `${multiplier.toFixed(2)}x`;
    if (popupAmt) popupAmt.textContent = amount % 1 === 0 ? amount.toFixed(0) : amount.toFixed(2);
    
    overlay.style.opacity = '1';
    overlay.style.pointerEvents = 'auto';
    if (overlay.firstElementChild) overlay.firstElementChild.style.transform = 'scale(1)';
    
    if (window.winPopupTimeout) clearTimeout(window.winPopupTimeout);
    window.winPopupTimeout = setTimeout(() => {
      overlay.style.opacity = '0';
      overlay.style.pointerEvents = 'none';
      if (overlay.firstElementChild) overlay.firstElementChild.style.transform = 'scale(0.9)';
    }, 1800);
  }

  // --- FLOATING TEXT & PARTICLES ENGINE (60Hz / 120Hz) ---
  function showFloatingText(element, text) {
    if (!element || !board) return;
    const rect = element.getBoundingClientRect();
    const containerRect = board.getBoundingClientRect();
    
    const ft = document.createElement('div');
    ft.className = 'floating-text';
    ft.textContent = text;
    
    const posX = (rect.left + rect.width / 2) - containerRect.left - 20;
    const posY = rect.top - containerRect.top - 10;
    
    ft.style.left = posX + 'px';
    ft.style.top = posY + 'px';
    
    board.appendChild(ft);
    setTimeout(() => ft.remove(), 1000);
  }

  function triggerScreenShake() {
    if (board) {
      board.classList.add('shake');
      setTimeout(() => board.classList.remove('shake'), 400);
    }
  }

  // --- HIGH FPS 60Hz / 120Hz CANVAS PARTICLE ENGINE ---
  const canvas = document.getElementById('particlesCanvas');
  let ctx = null;
  let activeParticles = [];
  let isAnimationRunning = false;

  function resizeCanvas() {
    if (!canvas) return;
    const dpr = window.devicePixelRatio || 1;
    canvas.width = window.innerWidth * dpr;
    canvas.height = window.innerHeight * dpr;
    if (ctx) {
      ctx.resetTransform();
      ctx.scale(dpr, dpr);
    }
  }

  if (canvas) {
    ctx = canvas.getContext('2d', { alpha: true });
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);
  }

  function renderParticlesLoop() {
    if (!ctx) return;
    ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

    for (let i = activeParticles.length - 1; i >= 0; i--) {
      const p = activeParticles[i];
      p.x += p.vx;
      p.y += p.vy;
      p.vy += p.gravity;
      p.alpha -= p.decay;
      p.size *= 0.97;

      if (p.alpha <= 0 || p.size <= 0.2) {
        activeParticles.splice(i, 1);
        continue;
      }

      ctx.save();
      ctx.globalAlpha = Math.max(0, p.alpha);
      ctx.fillStyle = p.color;
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    if (activeParticles.length > 0) {
      requestAnimationFrame(renderParticlesLoop);
    } else {
      isAnimationRunning = false;
    }
  }

  function createSuccessParticles(element) {
    if (!canvas || !ctx || !element) return;
    const rect = element.getBoundingClientRect();
    const clickX = rect.left + rect.width / 2;
    const clickY = rect.top + rect.height / 2;

    const colors = ['#24EE89', '#7c3aed', '#00e5ff', '#ffffff', '#f59e0b'];

    for (let i = 0; i < 25; i++) {
      const angle = Math.random() * Math.PI * 2;
      const speed = 2.5 + Math.random() * 6;
      activeParticles.push({
        x: clickX,
        y: clickY,
        vx: Math.cos(angle) * speed,
        vy: Math.sin(angle) * speed,
        gravity: 0.12,
        alpha: 1.0,
        decay: 0.02 + Math.random() * 0.02,
        size: 3.5 + Math.random() * 4,
        color: colors[Math.floor(Math.random() * colors.length)]
      });
    }

    if (!isAnimationRunning) {
      isAnimationRunning = true;
      requestAnimationFrame(renderParticlesLoop);
    }
  }

  // --- BUTTON LISTENERS ---
  if (btnBet) {
    btnBet.addEventListener('click', () => {
      sound.playClick();
      if (isPlaying) {
        if (revealed > 0) {
          endRound(true);
        } else {
          alert('Reveal at least one tile to Cash Out');
        }
      } else {
        initBoard();
        startRound();
      }
    });
  }

  if (btnRandom) {
    btnRandom.addEventListener('click', () => {
      sound.playClick();
      const hiddenIndices = [];
      tileStates.forEach((state, idx) => {
        if (state === 'hidden') hiddenIndices.push(idx);
      });
      
      if (hiddenIndices.length > 0) {
        const randIdx = hiddenIndices[Math.floor(Math.random() * hiddenIndices.length)];
        const tileEl = board ? board.children[randIdx] : null;
        if (tileEl) handleTileClick(randIdx, tileEl);
      }
    });
  }

  if (btnHalf) {
    btnHalf.addEventListener('click', () => {
      sound.playClick();
      let currentVal = parseFloat(betInput.value);
      if (!isNaN(currentVal)) {
        betInput.value = Math.max(0.01, parseFloat((currentVal / 2).toFixed(2)));
      }
    });
  }

  if (btnDouble) {
    btnDouble.addEventListener('click', () => {
      sound.playClick();
      let currentVal = parseFloat(betInput.value);
      if (!isNaN(currentVal)) {
        betInput.value = parseFloat((currentVal * 2).toFixed(2));
      }
    });
  }

  // Preset Amount Buttons (10, 50, 100, 500)
  document.querySelectorAll('.preset-btn[data-val]').forEach(btn => {
    btn.addEventListener('click', () => {
      sound.playClick();
      const val = parseFloat(btn.dataset.val);
      if (!isNaN(val) && betInput) {
        betInput.value = val.toFixed(2);
      }
    });
  });

  // Swap Button
  const btnSwap = document.getElementById('btnSwap');
  if (btnSwap) {
    btnSwap.addEventListener('click', () => {
      sound.playClick();
      let currentVal = parseFloat(betInput.value);
      if (!isNaN(currentVal) && currentVal > 0 && betInput) {
        betInput.value = (1000 / currentVal).toFixed(2);
      }
    });
  }

  // Mines Slider Listener
  if (minesSelect) {
    minesSelect.addEventListener('input', () => {
      const val = parseInt(minesSelect.value);
      if (minesValMin) minesValMin.textContent = val;
      updateMultipliersRoad();
    });
  }

  if (btnMute) {
    btnMute.addEventListener('click', () => {
      const muted = sound.toggleMute();
      if (speakerIcon) {
        if (muted) {
          speakerIcon.innerHTML = `
            <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
              <path d="M6.717 3.55A.5.5 0 0 1 7 4v8a.5.5 0 0 1-.812.39L3.825 10.5H1.5A.5.5 0 0 1 1 10V6a.5.5 0 0 1 .5-.5h2.325l2.363-1.89a.5.5 0 0 1 .529-.06zM6 5.04L4.312 6.39A.5.5 0 0 1 4 6.5H2v3h2a.5.5 0 0 1 .312.11L6 10.96V5.04zm7.854.146a.5.5 0 0 0-.708-.708L11.5 6.086 9.854 4.438a.5.5 0 0 0-.708.708L10.793 6.793 9.146 8.44a.5.5 0 0 0 .708.708L11.5 7.502l1.646 1.646a.5.5 0 0 0 .708-.708L12.207 6.793 13.854 5.146z"/>
            </svg>
          `;
        } else {
          speakerIcon.innerHTML = `
            <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
              <path d="M11.536 14.01A8.47 8.47 0 0 0 14.02 10a8.47 8.47 0 0 0-2.484-4.01L10.5 7.028A6.5 6.5 0 0 1 12 10a6.5 6.5 0 0 1-1.5 2.972l1.036 1.038z"/>
              <path d="M9.774 11.225A1 1 0 0 1 10 10a1 1 0 0 1-.226-.775l1.03-1.03A2.5 2.5 0 0 1 12 10a2.5 2.5 0 0 1-.422 1.455l-1.03-1.03z"/>
              <path d="M10.025 8a1 1 0 0 1-1 1v2a1 1 0 0 1 1 h.586l3.293 3.293c.63.63 1.707.184 1.707-.707V3.414c0-.89-1.077-1.337-1.707-.707L10.61 6H10.025z"/>
            </svg>
          `;
        }
      }
    });
  }

  if (btnBack) {
    btnBack.addEventListener('click', () => {
      sound.playClick();
      sendToFlutter('exitGame');
    });
  }

  const btnPlus = document.querySelector('.bcg-plus-btn');
  if (btnPlus) {
    btnPlus.addEventListener('click', () => {
      sound.playClick();
      sendToFlutter('openDeposit');
    });
  }

  // Tab Mode Toggle (Manual / Auto)
  const tabManual = document.getElementById('tabManual');
  const tabAuto = document.getElementById('tabAuto');
  const autoBetsGroup = document.getElementById('autoBetsGroup');
  
  if (tabManual) {
    tabManual.addEventListener('click', (e) => {
      sound.playClick();
      tabManual.classList.add('active');
      if (tabAuto) tabAuto.classList.remove('active');
      if (autoBetsGroup) autoBetsGroup.style.display = 'none';
    });
  }

  if (tabAuto) {
    tabAuto.addEventListener('click', (e) => {
      sound.playClick();
      if (tabManual) tabManual.classList.remove('active');
      tabAuto.classList.add('active');
      if (autoBetsGroup) autoBetsGroup.style.display = 'flex';
    });
  }

  // Auto Bets Preset Handlers (∞, 10, 100)
  const autoBetsInput = document.getElementById('autoBetsInput');
  document.querySelectorAll('.auto-preset').forEach(btn => {
    btn.addEventListener('click', () => {
      sound.playClick();
      const bets = btn.dataset.bets;
      if (autoBetsInput) {
        autoBetsInput.value = bets === 'inf' ? '∞' : bets;
      }
    });
  });

  // --- INITIALIZATION ---
  initBoard();
  updateUI();

})();
