import { Router, Request, Response } from 'express';
import { PILOT_AUDIO_GUIDES, PANIC_SCENARIOS } from '../data/seedData.js';

export const pilotRouter = Router();

pilotRouter.get('/guides', (_req: Request, res: Response): void => {
  res.json({
    success: true,
    total: PILOT_AUDIO_GUIDES.length,
    guides: PILOT_AUDIO_GUIDES,
  });
});

pilotRouter.get('/panic-scenarios', (_req: Request, res: Response): void => {
  res.json({
    success: true,
    total: PANIC_SCENARIOS.length,
    scenarios: PANIC_SCENARIOS,
  });
});
