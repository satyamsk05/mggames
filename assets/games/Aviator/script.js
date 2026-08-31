// Game State
const gameState = {
    phase: 'waiting', // waiting, running, crashed
    multiplier: 1.00,
    countdown: 5.0,
    crashPoint: 1.00,
    startTime: null,
    elapsedTime: 0,
    rotationAngle: 0,
    animationFrame: null
};

// Two independent bet panels states
const bets = {
    1: {
        placed: false,
        amount: 10.00,
        isAutoBet: false,
        isAutoCashout: false,
        autoCashoutAt: 1.25,
        activeInRound: false
    },
    2: {
        placed: false,
        amount: 10.00,
        isAutoBet: false,
        isAutoCashout: false,
        autoCashoutAt: 1.25,
        activeInRound: false
    }
};

let balance = 150.57;

// Parse query params
const urlParams = new URLSearchParams(window.location.search);
const urlBal = parseFloat(urlParams.get('balance'));
if (!isNaN(urlBal)) {
    balance = urlBal;
}

// DOM elements
const canvas = document.getElementById('flightCanvas');
const ctx = canvas.getContext('2d');
const balanceText = document.getElementById('balanceText');
const multiplierValue = document.getElementById('multiplierValue');
const multiplierX = document.getElementById('multiplierX');
const multiplierDisplay = document.getElementById('multiplierDisplay');
const crashedLabel = document.getElementById('crashedLabel');
const loadingOverlay = document.getElementById('loadingOverlay');
const progressBar = document.getElementById('progressBar');
const loadingTime = document.getElementById('loadingTime');
const historyBar = document.getElementById('historyBar');
const winNotification = document.getElementById('winNotification');
const propellerBox = document.getElementById('propellerBox');
const betsList = document.getElementById('betsList');

// Dynamic SVG Images
const propellerImg = new Image();
propellerImg.src = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 200' width='200' height='200'><circle cx='100' cy='100' r='90' fill='none' stroke='rgba(211, 47, 47, 0.15)' stroke-width='4' stroke-dasharray='12 6'/><path d='M 100,100 L 100,10 C 100,10 90,40 90,80 Z' fill='%23d32f2f' opacity='0.9'/><path d='M 100,100 L 100,190 C 100,190 110,160 110,120 Z' fill='%23d32f2f' opacity='0.9'/><circle cx='100' cy='100' r='30' fill='none' stroke='%23d32f2f' stroke-width='6'/><circle cx='100' cy='100' r='15' fill='%23111111'/></svg>";

const planeImg = new Image();
planeImg.src = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 80' width='160' height='80'><path d='M 32,32 L 20,10 C 18,7 23,4 27,6 L 39,26 Z' fill='%23d32f2f'/><path d='M 28,32 L 12,24 C 10,23 12,20 15,21 L 28,27 Z' fill='%23b71c1c'/><path d='M 25,48 C 25,30 55,22 110,22 C 125,22 135,28 142,35 C 148,42 145,50 135,50 C 100,50 40,52 25,48 Z' fill='%23d32f2f' stroke='%23991b1b' stroke-width='2.5'/><path d='M 75,27 C 82,15 112,15 120,27 Z' fill='rgba(255, 255, 255, 0.3)' stroke='rgba(255, 255, 255, 0.6)' stroke-width='1.5'/><path d='M 141,33 C 145,33 149,38 149,42 C 149,46 145,50 141,50 Z' fill='%23111111'/><ellipse cx='147' cy='41' rx='2.5' ry='38' fill='rgba(255,255,255,0.7)'/><path d='M 85,44 C 85,44 110,65 118,65 C 125,65 125,44 85,44 Z' fill='%23d32f2f' stroke='%23991b1b' stroke-width='1.5'/></svg>";

propellerBox.appendChild(propellerImg);

function setupCanvas() {
    const rect = canvas.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    canvas.width = rect.width * dpr;
    canvas.height = rect.height * dpr;
    ctx.scale(dpr, dpr);
}

function generateCrashPoint() {
    const houseEdge = 0.035;
    if (Math.random() < houseEdge) return 1.00;
    const rand = Math.random();
    const point = 0.98 / (1 - rand);
    return Math.max(1.00, Math.min(point, 1000));
}

// Draw Matte Black Canvas Background with Sunburst rays
function drawBackground() {
    const width = canvas.width / (window.devicePixelRatio || 1);
    const height = canvas.height / (window.devicePixelRatio || 1);

    // Matte Black background
    ctx.fillStyle = '#0f1011';
    ctx.fillRect(0, 0, width, height);

    // Sunburst rays expanding from bottom-left
    const cx = 35;
    const cy = height - 40;
    const numRays = 30;
    const rayMaxLen = Math.max(width, height) * 1.5;
    
    ctx.fillStyle = 'rgba(211, 47, 47, 0.03)';
    for (let i = 0; i < numRays; i++) {
        const angle1 = (i / numRays) * 0.5 * Math.PI + gameState.rotationAngle;
        const angle2 = ((i + 0.4) / numRays) * 0.5 * Math.PI + gameState.rotationAngle;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + Math.cos(angle1) * rayMaxLen, cy - Math.sin(angle1) * rayMaxLen);
        ctx.lineTo(cx + Math.cos(angle2) * rayMaxLen, cy - Math.sin(angle2) * rayMaxLen);
        ctx.closePath();
        ctx.fill();
    }

    // Grid bounds borders (Axes lines)
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.05)';
    ctx.lineWidth = 1;
    // Horizontal grid line bottom
    ctx.beginPath();
    ctx.moveTo(35, height - 40);
    ctx.lineTo(width - 20, height - 40);
    ctx.stroke();

    // Vertical grid line left
    ctx.beginPath();
    ctx.moveTo(35, 20);
    ctx.lineTo(35, height - 40);
    ctx.stroke();
}

// Draw running curve trail and coordinate lines
function drawFlightScene() {
    const width = canvas.width / (window.devicePixelRatio || 1);
    const height = canvas.height / (window.devicePixelRatio || 1);
    const padding = { left: 35, right: 60, bottom: 40, top: 40 };

    const plotWidth = width - padding.left - padding.right;
    const plotHeight = height - padding.bottom - padding.top;

    if (gameState.phase === 'running') {
        const elapsed = gameState.elapsedTime;
        const maxTime = Math.max(elapsed * 1.2, 4.0);
        const maxVal = Math.max(gameState.multiplier, 2.0);

        const points = [];
        const steps = 100;
        for (let i = 0; i <= steps; i++) {
            const t = (i / steps) * elapsed;
            const val = Math.pow(Math.E, 0.08 * t);
            
            const x = padding.left + (t / maxTime) * plotWidth;
            const y = height - padding.bottom - ((val - 1.0) / (maxVal - 1.0)) * plotHeight;
            points.push({ x, y });
        }

        const planePos = points[points.length - 1];

        // 1. Draw Translucent Red Flight Trail Fill
        const trailGrad = ctx.createLinearGradient(0, height, 0, padding.top);
        trailGrad.addColorStop(0, 'rgba(211, 47, 47, 0.01)');
        trailGrad.addColorStop(1, 'rgba(211, 47, 47, 0.35)');

        ctx.beginPath();
        ctx.moveTo(padding.left, height - padding.bottom);
        points.forEach(p => ctx.lineTo(p.x, p.y));
        ctx.lineTo(planePos.x, height - padding.bottom);
        ctx.closePath();
        ctx.fillStyle = trailGrad;
        ctx.fill();

        // 2. Draw Curve Border Stroke (Red Line)
        ctx.beginPath();
        ctx.moveTo(padding.left, height - padding.bottom);
        points.forEach(p => ctx.lineTo(p.x, p.y));
        ctx.strokeStyle = '#e53935';
        ctx.lineWidth = 3.5;
        ctx.lineCap = 'round';
        ctx.stroke();

        // 3. Draw Dotted White Coordinate Lines
        ctx.strokeStyle = 'rgba(255, 255, 255, 0.25)';
        ctx.lineWidth = 1;
        ctx.setLineDash([4, 4]);

        // Vertical dotted line to bottom
        ctx.beginPath();
        ctx.moveTo(planePos.x, planePos.y);
        ctx.lineTo(planePos.x, height - padding.bottom);
        ctx.stroke();

        // Horizontal dotted line to left
        ctx.beginPath();
        ctx.moveTo(planePos.x, planePos.y);
        ctx.lineTo(padding.left, planePos.y);
        ctx.stroke();

        ctx.setLineDash([]); // Reset

        // 4. Draw Flying Red Plane Image
        const planeW = 80;
        const planeH = 40;
        ctx.save();
        ctx.translate(planePos.x, planePos.y);
        ctx.drawImage(planeImg, -planeW * 0.75, -planeH * 0.5, planeW, planeH);
        ctx.restore();
    }
}

function render() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    drawBackground();
    drawFlightScene();
}

// Wallet Balance Updates
function updateBalanceDisplay() {
    balanceText.textContent = balance.toFixed(2);
}

function sendToFlutter(type, data = {}) {
    window.parent.postMessage(JSON.stringify({ type, ...data }), '*');
    if (window.MinesChannel) {
        window.MinesChannel.postMessage(JSON.stringify({ type, ...data }));
    }
}

window.setBalanceFromFlutter = function(newBal) {
    balance = parseFloat(newBal);
    updateBalanceDisplay();
};

// Adjust tab mode for panels
function setPanelTab(panelId, mode) {
    const panel = document.getElementById(`panel${panelId}`);
    const tabs = panel.querySelectorAll('.panel-tab');
    tabs.forEach(t => t.classList.remove('active'));
    
    const betBox = document.getElementById(`betBox${panelId}`);
    const autoControls = document.getElementById(`autoControls${panelId}`);

    if (mode === 'bet') {
        tabs[0].classList.add('active');
        betBox.style.display = 'flex';
        autoControls.style.display = 'none';
    } else {
        tabs[1].classList.add('active');
        betBox.style.display = 'none';
        autoControls.style.display = 'flex';
    }
}

// Adjust bet amount by delta (-10, +10)
function adjustBet(panelId, delta) {
    const input = document.getElementById(`betAmount${panelId}`);
    let val = parseFloat(input.value) || 10;
    val = Math.max(1, val + delta);
    input.value = val.toFixed(2);
    bets[panelId].amount = val;
    updatePanelBtnText(panelId);
}

// Quick set bet value helper
function setQuickBet(panelId, value) {
    const input = document.getElementById(`betAmount${panelId}`);
    input.value = parseFloat(value).toFixed(2);
    bets[panelId].amount = parseFloat(value);
    updatePanelBtnText(panelId);
}

// Validate manual input
window.validateBetInput = function(panelId) {
    const input = document.getElementById(`betAmount${panelId}`);
    let val = parseFloat(input.value);
    if (isNaN(val) || val <= 0) val = 10.00;
    input.value = val.toFixed(2);
    bets[panelId].amount = val;
    updatePanelBtnText(panelId);
};

function updatePanelBtnText(panelId) {
    const sub = document.getElementById(`betBtnSub${panelId}`);
    if (gameState.phase === 'waiting' && !bets[panelId].placed) {
        sub.textContent = `${bets[panelId].amount.toFixed(2)} INR`;
    }
}

// UI Panel button updates helper
function updatePanelUI(panelId) {
    const btn = document.getElementById(`betBtn${panelId}`);
    const title = document.getElementById(`betBtnTitle${panelId}`);
    const sub = document.getElementById(`betBtnSub${panelId}`);
    const pState = bets[panelId];

    if (gameState.phase === 'waiting') {
        btn.className = 'place-bet-btn';
        btn.style.background = '';
        btn.style.boxShadow = '';
        btn.style.border = '';
        btn.style.color = '';
        if (pState.placed) {
            btn.style.background = 'linear-gradient(180deg, #d32f2f 0%, #b71c1c 100%)';
            btn.style.border = '1px solid #991b1b';
            btn.style.color = '#ffffff';
            btn.style.boxShadow = '0 4px 12px rgba(211, 47, 47, 0.2)';
            title.textContent = 'Cancel';
            sub.textContent = 'Bet is Placed';
        } else {
            title.textContent = 'Bet';
            sub.textContent = `${pState.amount.toFixed(2)} INR`;
        }
    } else if (gameState.phase === 'running') {
        if (pState.activeInRound) {
            btn.className = 'place-bet-btn cashout';
            btn.style.background = '';
            btn.style.boxShadow = '';
            btn.style.border = '';
            btn.style.color = '';
            title.textContent = 'Cash Out';
            const payout = pState.amount * gameState.multiplier;
            sub.textContent = `₹${payout.toFixed(2)}`;
        } else {
            btn.className = 'place-bet-btn waiting-btn';
            btn.style.background = '';
            btn.style.boxShadow = '';
            btn.style.border = '';
            btn.style.color = '';
            title.textContent = 'Bet';
            sub.textContent = 'Waiting for next round';
        }
    } else {
        // crashed
        btn.className = 'place-bet-btn waiting-btn';
        btn.style.background = '';
        btn.style.boxShadow = '';
        btn.style.border = '';
        btn.style.color = '';
        title.textContent = 'Bet';
        sub.textContent = 'Next Round';
    }
}

// Handle Bet click triggers
window.handleBetClick = function(panelId) {
    const pState = bets[panelId];

    if (gameState.phase === 'waiting') {
        if (!pState.placed) {
            // Place bet
            const amt = pState.amount;
            if (amt > balance) {
                alert('Insufficient balance!');
                return;
            }
            balance = parseFloat((balance - amt).toFixed(2));
            updateBalanceDisplay();
            sendToFlutter('updateBalance', { balance });

            pState.placed = true;
        } else {
            // Cancel bet
            balance = parseFloat((balance + pState.amount).toFixed(2));
            updateBalanceDisplay();
            sendToFlutter('updateBalance', { balance });

            pState.placed = false;
        }
        updatePanelUI(panelId);
    } else if (gameState.phase === 'running') {
        if (pState.activeInRound) {
            // Perform manual cashout
            cashoutBet(panelId);
        }
    }
};

// Perform Cashout logic
function cashoutBet(panelId) {
    const pState = bets[panelId];
    if (!pState.activeInRound) return;

    const winAmt = pState.amount * gameState.multiplier;
    const roundedWin = parseFloat(winAmt.toFixed(2));

    balance = parseFloat((balance + roundedWin).toFixed(2));
    updateBalanceDisplay();
    sendToFlutter('updateBalance', { balance });

    showWinNotification(roundedWin, gameState.multiplier);

    // Add cashout row to list
    addLiveBetRow('k***', pState.amount, gameState.multiplier, roundedWin, true);

    // Reset bet status
    pState.placed = false;
    pState.activeInRound = false;
    updatePanelUI(panelId);
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
    
    document.getElementById('win-popup-multiplier').textContent = `${multiplier.toFixed(2)}x`;
    document.getElementById('win-popup-amount').textContent = amount % 1 === 0 ? amount.toFixed(0) : amount.toFixed(2);
    
    overlay.style.opacity = '1';
    overlay.style.pointerEvents = 'auto';
    overlay.firstElementChild.style.transform = 'scale(1)';
    
    if (window.winPopupTimeout) clearTimeout(window.winPopupTimeout);
    window.winPopupTimeout = setTimeout(() => {
        overlay.style.opacity = '0';
        overlay.style.pointerEvents = 'none';
        overlay.firstElementChild.style.transform = 'scale(0.9)';
    }, 1800);
}

// Add to history scroll
function addToHistory(mult) {
    const category = mult < 1.5 ? 'low' : mult < 4.0 ? 'medium' : 'high';
    const pill = document.createElement('div');
    pill.className = `history-pill ${category}`;
    pill.textContent = `${mult.toFixed(2)}x`;
    
    historyBar.insertBefore(pill, historyBar.firstChild);
    while (historyBar.children.length > 10) {
        historyBar.removeChild(historyBar.lastChild.previousSibling); // Keep clock icon last
    }
}

// Live Bets Simulation & Logs
function addLiveBetRow(user, bet, mult, cashout, isUser = false) {
    const row = document.createElement('div');
    row.className = `bet-row ${isUser ? 'won' : ''}`;
    
    const initials = user.substring(0, 2).toUpperCase();
    
    row.innerHTML = `
        <span class="user-col">
            <span class="user-avatar" style="background: ${isUser ? '#28a745' : '#ff8f00'}">${initials}</span>
            <span>${user}</span>
        </span>
        <span class="amt-col">${bet.toFixed(0)}</span>
        <span class="mult-col ${cashout > 0 ? 'won-mult' : ''}">${cashout > 0 ? mult.toFixed(2) + 'x' : '-'}</span>
        <span class="payout-col ${cashout > 0 ? 'won-payout' : ''}">${cashout > 0 ? '₹' + cashout.toFixed(0) : '-'}</span>
    `;
    betsList.insertBefore(row, betsList.firstChild);
    
    // Limit logs
    while (betsList.children.length > 25) {
        betsList.removeChild(betsList.lastChild);
    }
}

function simulateOtherPlayersBetting() {
    // Generate list of initial random players
    const names = ['r***', 's***', 'a***', 'j***', 'm***', 't***', 'p***', 'l***', 'd***'];
    for (let i = 0; i < 15; i++) {
        const user = names[Math.floor(Math.random() * names.length)] + Math.floor(Math.random() * 999);
        const bet = 100 + Math.floor(Math.random() * 9) * 100;
        addLiveBetRow(user, bet, 0, 0);
    }
}

function simulateOtherPlayersCashingOut() {
    if (gameState.phase !== 'running') return;
    // Periodically check if some simulated players cashout
    const kids = Array.from(betsList.children);
    kids.forEach(row => {
        if (!row.classList.contains('won') && Math.random() < 0.08) {
            const amtCol = row.querySelector('.amt-col');
            const multCol = row.querySelector('.mult-col');
            const payoutCol = row.querySelector('.payout-col');
            
            if (multCol && multCol.textContent === '-') {
                const betVal = parseFloat(amtCol.textContent) || 100;
                const roundedCash = parseFloat((betVal * gameState.multiplier).toFixed(0));
                
                multCol.className = 'mult-col won-mult';
                multCol.textContent = `${gameState.multiplier.toFixed(2)}x`;
                
                payoutCol.className = 'payout-col won-payout';
                payoutCol.textContent = `₹${roundedCash}`;
                row.style.background = 'rgba(255, 255, 255, 0.02)';
            }
        }
    });
}

// Game Loops
function gameLoop() {
    if (gameState.phase === 'running') {
        const elapsed = (Date.now() - gameState.startTime) / 1000;
        gameState.elapsedTime = elapsed;
        
        // Growth rate
        gameState.multiplier = Math.pow(Math.E, 0.082 * elapsed);

        // Rotate Sunburst rays
        gameState.rotationAngle += 0.005;

        // Check crash event
        if (gameState.multiplier >= gameState.crashPoint) {
            gameState.multiplier = gameState.crashPoint;
            gameState.phase = 'crashed';
            handleCrash();
        }

        // Check Auto Cashouts
        [1, 2].forEach(panelId => {
            const pState = bets[panelId];
            const cashoutToggle = document.getElementById(`autoCashoutToggle${panelId}`);
            if (pState.activeInRound && cashoutToggle && cashoutToggle.checked) {
                const target = parseFloat(document.getElementById(`autoCashoutAt${panelId}`).value) || 1.25;
                if (gameState.multiplier >= target) {
                    cashoutBet(panelId);
                }
            }
        });

        // Update Multiplier centered label
        multiplierValue.textContent = gameState.multiplier.toFixed(2);
        
        // Update live cashout text in panel buttons
        [1, 2].forEach(pId => updatePanelUI(pId));

        // Sim cashing out
        simulateOtherPlayersCashingOut();

        render();

        if (gameState.phase === 'running') {
            gameState.animationFrame = requestAnimationFrame(gameLoop);
        }
    }
}

// Start Countdown waiting phase
function startCountdown() {
    gameState.phase = 'waiting';
    gameState.countdown = 5.0;
    gameState.multiplier = 1.00;
    gameState.elapsedTime = 0;

    // Reset multiplier label styles
    multiplierDisplay.style.display = 'none';
    crashedLabel.style.display = 'none';
    multiplierValue.style.color = '#ffffff';
    multiplierX.style.color = '#ffffff';
    loadingOverlay.classList.remove('hidden');

    // Refresh simulated player list
    betsList.innerHTML = '';
    simulateOtherPlayersBetting();

    // Auto Bet lock-in for waiting state
    [1, 2].forEach(panelId => {
        const pState = bets[panelId];
        const autoBetToggle = document.getElementById(`autoBetToggle${panelId}`);
        if (autoBetToggle && autoBetToggle.checked) {
            const amt = pState.amount;
            if (amt <= balance) {
                balance = parseFloat((balance - amt).toFixed(2));
                updateBalanceDisplay();
                sendToFlutter('updateBalance', { balance });
                pState.placed = true;
            }
        }
    });

    [1, 2].forEach(pId => updatePanelUI(pId));
    render();

    const countdownInterval = setInterval(() => {
        gameState.countdown -= 0.1;
        if (gameState.countdown <= 0) {
            gameState.countdown = 0;
            clearInterval(countdownInterval);
            startRound();
        } else {
            loadingTime.textContent = `${gameState.countdown.toFixed(1)}s`;
            progressBar.style.width = `${(gameState.countdown / 5.0) * 100}%`;
        }
    }, 100);
}

// Start round flight phase
function startRound() {
    gameState.phase = 'running';
    gameState.startTime = Date.now();
    gameState.crashPoint = generateCrashPoint();

    loadingOverlay.classList.add('hidden');
    multiplierDisplay.style.display = 'block';
    multiplierValue.textContent = '1.00';

    // Lock bets in round
    [1, 2].forEach(panelId => {
        const pState = bets[panelId];
        if (pState.placed) {
            pState.activeInRound = true;
        } else {
            pState.activeInRound = false;
        }
        updatePanelUI(panelId);
    });

    gameLoop();
}

// Handle crash event
function handleCrash() {
    addToHistory(gameState.multiplier);
    render();

    // Show Crashed flight status
    crashedLabel.style.display = 'block';
    multiplierValue.style.color = '#e53935';
    multiplierX.style.color = '#e53935';

    // Clear unmatched active bets
    [1, 2].forEach(panelId => {
        bets[panelId].placed = false;
        bets[panelId].activeInRound = false;
        updatePanelUI(panelId);
    });

    setTimeout(() => {
        startCountdown();
    }, 3000);
}

// Back Button
document.getElementById('btnBack').addEventListener('click', () => {
    sendToFlutter('exitGame');
});

// Initialize App
window.addEventListener('resize', () => {
    setupCanvas();
    render();
});

document.addEventListener('DOMContentLoaded', () => {
    setupCanvas();
    updateBalanceDisplay();
    startCountdown();
});

// Bind window functions
window.setPanelTab = setPanelTab;
window.adjustBet = adjustBet;
window.setQuickBet = setQuickBet;
