import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import { flightRouter } from './routes/flightRoutes.js';
import { soundRouter } from './routes/soundRoutes.js';
import { aircraftRouter } from './routes/aircraftRoutes.js';
import { pilotRouter } from './routes/pilotRoutes.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env['PORT'] || 3000;

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Mobile device redirect for root URL
app.get('/', (req, res, next) => {
  const ua = req.headers['user-agent'] || '';
  if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(ua) && !req.query.desktop) {
    return res.redirect('/mobile.html');
  }
  next();
});

// Serve static inspector dashboard
const publicDir = path.join(__dirname, '..', 'public');
app.use(express.static(publicDir));

// API v1 Routes
app.use('/api/v1/flight', flightRouter);
app.use('/api/v1/sounds', soundRouter);
app.use('/api/v1/aircraft', aircraftRouter);
app.use('/api/v1/pilot', pilotRouter);

// Health check
app.get('/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'Flight Copilot Backend & Pre-Flight Sync Engine',
    timestamp: new Date().toISOString(),
    uptimeSec: Math.round(process.uptime()),
  });
});

// Root API description
app.get('/api/v1', (_req, res) => {
  res.json({
    name: 'Flight Anxiety Copilot API',
    version: '1.0.0',
    endpoints: {
      flightSync: 'POST /api/v1/flight/sync',
      decodeBarcode: 'POST /api/v1/flight/decode-barcode',
      samplePasses: 'GET /api/v1/flight/sample-passes',
      sounds: 'GET /api/v1/sounds',
      aircraft: 'GET /api/v1/aircraft',
      pilotGuides: 'GET /api/v1/pilot/guides',
      panicScenarios: 'GET /api/v1/pilot/panic-scenarios',
    },
  });
});

app.listen(PORT, () => {
  console.log(`✈️ Flight Copilot Backend running on http://localhost:${PORT}`);
  console.log(`📡 Pre-Flight Sync API active on http://localhost:${PORT}/api/v1/flight/sync`);
  console.log(`🎛️ Cockpit Inspector Dashboard on http://localhost:${PORT}/`);
});
