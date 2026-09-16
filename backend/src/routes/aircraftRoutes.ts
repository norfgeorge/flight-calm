import { Router, Request, Response } from 'express';
import { AIRCRAFT_PROFILES } from '../data/seedData.js';

export const aircraftRouter = Router();

aircraftRouter.get('/', (_req: Request, res: Response): void => {
  res.json({
    success: true,
    total: Object.keys(AIRCRAFT_PROFILES).length,
    aircraft: Object.values(AIRCRAFT_PROFILES),
  });
});

aircraftRouter.get('/:icao', (req: Request, res: Response): void => {
  const icao = req.params['icao']?.toUpperCase();
  const profile = AIRCRAFT_PROFILES[icao || ''];
  if (!profile) {
    res.status(404).json({ success: false, error: 'Profilul aeronavei nu a fost găsit.' });
    return;
  }
  res.json({ success: true, profile });
});
