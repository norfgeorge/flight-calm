import { Router, Request, Response } from 'express';
import { IataDecoderService } from '../services/iataDecoder.js';
import { BundleService } from '../services/bundleService.js';
import { IataBoardingPass } from '../types/index.js';

export const flightRouter = Router();

/**
 * POST /api/v1/flight/sync
 * The core Pre-Flight gate synchronization endpoint.
 * Accepts an IATA barcode string or parsed fields, returns complete offline bundle (<15MB).
 */
flightRouter.post('/sync', (req: Request, res: Response): void => {
  try {
    const { rawBarcode, flightNumber, origin, destination, passengerName } = req.body;

    let ticket: IataBoardingPass;

    if (rawBarcode && typeof rawBarcode === 'string' && rawBarcode.length >= 10) {
      ticket = IataDecoderService.decode(rawBarcode);
    } else if (flightNumber) {
      const carrier = flightNumber.substring(0, 2).toUpperCase();
      ticket = {
        rawBarcode: `MANUAL_${flightNumber}`,
        formatCode: 'M',
        numberOfLegs: 1,
        passengerName: passengerName || 'Pasager',
        pnr: 'TKT123',
        originAirport: (origin || 'OTP').toUpperCase(),
        destinationAirport: (destination || 'CDG').toUpperCase(),
        operatingCarrier: carrier,
        flightNumber: flightNumber.toUpperCase(),
        julianDate: 258,
        compartmentCode: 'Y',
        seatNumber: '14B',
        checkinSequence: '042',
        flightDateFormatted: new Date().toISOString().split('T')[0]!,
      };
    } else {
      // Default demo ticket
      const sample = IataDecoderService.generateSamplePass();
      ticket = IataDecoderService.decode(sample);
    }

    const bundle = BundleService.generateBundle(ticket);
    res.json({
      success: true,
      message: 'Pachetul offline de zbor a fost sincronizat cu succes.',
      bundle,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: error.message || 'Eroare la decodarea sau generarea pachetului de zbor.',
    });
  }
});

/**
 * POST /api/v1/flight/decode-barcode
 * Diagnostic endpoint to inspect raw IATA barcode decoding
 */
flightRouter.post('/decode-barcode', (req: Request, res: Response): void => {
  try {
    const { rawBarcode } = req.body;
    if (!rawBarcode) {
      res.status(400).json({ success: false, error: 'Câmpul rawBarcode este obligatoriu.' });
      return;
    }
    const decoded = IataDecoderService.decode(rawBarcode);
    res.json({ success: true, decoded });
  } catch (error: any) {
    res.status(400).json({ success: false, error: error.message });
  }
});

/**
 * GET /api/v1/flight/sample-passes
 * Provides realistic IATA barcodes for testing scanning from another phone or monitor
 */
flightRouter.get('/sample-passes', (_req: Request, res: Response): void => {
  const passes = [
    {
      airline: 'TAROM',
      flight: 'RO391',
      route: 'București (OTP) ➔ Paris (CDG)',
      aircraft: 'Boeing 737-800',
      pax: 'POPESCU / ANDREI MR',
      seat: '14B',
      barcode: IataDecoderService.generateSamplePass({
        passengerName: 'POPESCU/ANDREI MR',
        carrier: 'RO',
        flightDigits: '0391',
        origin: 'OTP',
        destination: 'CDG',
        seat: '14B',
      }),
    },
    {
      airline: 'Lufthansa',
      flight: 'LH1420',
      route: 'Frankfurt (FRA) ➔ București (OTP)',
      aircraft: 'Airbus A321neo',
      pax: 'MULLER / HANS MR',
      seat: '08A',
      barcode: IataDecoderService.generateSamplePass({
        passengerName: 'MULLER/HANS MR',
        carrier: 'LH',
        flightDigits: '1420',
        origin: 'FRA',
        destination: 'OTP',
        seat: '08A',
      }),
    },
    {
      airline: 'Wizz Air',
      flight: 'W63001',
      route: 'București (OTP) ➔ Londra (LHR)',
      aircraft: 'Airbus A321neo',
      pax: 'IONESCU / MARIA MS',
      seat: '22F',
      barcode: IataDecoderService.generateSamplePass({
        passengerName: 'IONESCU/MARIA MS',
        carrier: 'W6',
        flightDigits: '3001',
        origin: 'OTP',
        destination: 'LHR',
        seat: '22F',
      }),
    },
  ];

  res.json({ success: true, passes });
});
