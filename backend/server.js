const express = require('express');
const cors = require('cors');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const PORT = 3001;

// ─── Middleware ───────────────────────────────────────────────────────────────
app.use(cors({ origin: '*' }));
app.use(express.json());

// ─── In-Memory Balance Store ──────────────────────────────────────────────────
// Simple demo: one shared balance (extend with userId for multi-user)
let gameState = {
  balance: 150.57,
  inGame: false,
  betAmount: 0,
  minesCount: 3,
  tilesRevealed: 0,
};

// Connected WebSocket clients (Flutter app listens here)
const wsClients = new Set();

// Broadcast new balance to ALL connected Flutter/Web clients
function broadcast(data) {
  const msg = JSON.stringify(data);
  wsClients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(msg);
    }
  });
}

// ─── REST API Routes ──────────────────────────────────────────────────────────

// GET /api/balance → Return current balance
app.get('/api/balance', (req, res) => {
  res.json({ success: true, balance: gameState.balance });
});

// POST /api/game/bet → Deduct bet amount, start game
app.post('/api/game/bet', (req, res) => {
  const { amount, minesCount } = req.body;

  if (!amount || amount <= 0) {
    return res.status(400).json({ success: false, error: 'Invalid bet amount' });
  }
  if (amount > gameState.balance) {
    return res.status(400).json({ success: false, error: 'Insufficient balance' });
  }
  if (gameState.inGame) {
    return res.status(400).json({ success: false, error: 'Game already in progress' });
  }

  // Deduct balance
  gameState.balance = Math.round((gameState.balance - amount) * 100) / 100;
  gameState.inGame = true;
  gameState.betAmount = amount;
  gameState.minesCount = minesCount || 3;
  gameState.tilesRevealed = 0;

  // Broadcast updated balance to Flutter
  broadcast({ type: 'updateBalance', balance: gameState.balance });

  console.log(`[BET] ₹${amount} placed. Mines: ${minesCount}. New balance: ₹${gameState.balance}`);

  res.json({
    success: true,
    balance: gameState.balance,
    betAmount: gameState.betAmount,
  });
});

// POST /api/game/cashout → Credit winnings, end game
app.post('/api/game/cashout', (req, res) => {
  const { multiplier } = req.body;

  if (!gameState.inGame) {
    return res.status(400).json({ success: false, error: 'No game in progress' });
  }

  const winAmount = Math.round(gameState.betAmount * (multiplier || 1) * 100) / 100;
  gameState.balance = Math.round((gameState.balance + winAmount) * 100) / 100;
  gameState.inGame = false;

  // Broadcast updated balance to Flutter
  broadcast({ type: 'updateBalance', balance: gameState.balance });

  console.log(`[CASHOUT] ×${multiplier} = ₹${winAmount}. New balance: ₹${gameState.balance}`);

  res.json({
    success: true,
    winAmount,
    balance: gameState.balance,
  });
});

// POST /api/game/lose → Game lost (hit mine)
app.post('/api/game/lose', (req, res) => {
  if (!gameState.inGame) {
    return res.status(400).json({ success: false, error: 'No game in progress' });
  }

  gameState.inGame = false;

  // Broadcast updated balance (already deducted at bet time)
  broadcast({ type: 'updateBalance', balance: gameState.balance });

  console.log(`[LOSE] Hit mine. Balance stays: ₹${gameState.balance}`);

  res.json({ success: true, balance: gameState.balance });
});

// POST /api/balance/set → Manually set balance (for testing)
app.post('/api/balance/set', (req, res) => {
  const { balance } = req.body;
  gameState.balance = balance;
  broadcast({ type: 'updateBalance', balance: gameState.balance });
  res.json({ success: true, balance: gameState.balance });
});

// GET /api/state → Full game state (debug)
app.get('/api/state', (req, res) => {
  res.json({ success: true, state: gameState });
});

// ─── HTTP Server + WebSocket ──────────────────────────────────────────────────
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
  wsClients.add(ws);
  console.log(`[WS] Client connected. Total: ${wsClients.size}`);

  // Send current balance immediately on connect
  ws.send(JSON.stringify({ type: 'updateBalance', balance: gameState.balance }));

  ws.on('close', () => {
    wsClients.delete(ws);
    console.log(`[WS] Client disconnected. Total: ${wsClients.size}`);
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 BC.Game Backend running!`);
  console.log(`   Local:   http://localhost:${PORT}`);
  console.log(`   Network: http://<your-ip>:${PORT}`);
  console.log(`\n📡 WebSocket: ws://localhost:${PORT}`);
  console.log(`\n📋 API Routes:`);
  console.log(`   GET  /api/balance`);
  console.log(`   POST /api/game/bet       { amount, minesCount }`);
  console.log(`   POST /api/game/cashout   { multiplier }`);
  console.log(`   POST /api/game/lose`);
  console.log(`   GET  /api/state`);
});
