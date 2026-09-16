import { Router, Request, Response } from 'express';
import { MECHANICAL_SOUNDS } from '../data/seedData.js';

export const soundRouter = Router();

soundRouter.get('/', (_req: Request, res: Response): void => {
  res.json({
    success: true,
    total: MECHANICAL_SOUNDS.length,
    sounds: MECHANICAL_SOUNDS,
  });
});

soundRouter.get('/:id', (req: Request, res: Response): void => {
  const sound = MECHANICAL_SOUNDS.find((s) => s.id === req.params['id']);
  if (!sound) {
    res.status(404).json({ success: false, error: 'Sunetul mecanic nu a fost găsit.' });
    return;
  }
  res.json({ success: true, sound });
});
