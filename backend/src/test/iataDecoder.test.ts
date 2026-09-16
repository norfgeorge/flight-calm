import test from 'node:test';
import assert from 'node:assert/strict';
import { IataDecoderService } from '../services/iataDecoder.js';
import { BundleService } from '../services/bundleService.js';

test('IATA Decoder parses standard Resolution 792 BCBP barcode', () => {
  const sample = IataDecoderService.generateSamplePass({
    passengerName: 'POPESCU/ANDREI MR',
    carrier: 'RO',
    flightDigits: '0391',
    origin: 'OTP',
    destination: 'CDG',
    seat: '14B',
  });

  const decoded = IataDecoderService.decode(sample);

  assert.equal(decoded.formatCode, 'M');
  assert.equal(decoded.passengerName, 'Andrei Popescu');
  assert.equal(decoded.operatingCarrier, 'RO');
  assert.equal(decoded.flightNumber, 'RO391');
  assert.equal(decoded.originAirport, 'OTP');
  assert.equal(decoded.destinationAirport, 'CDG');
  assert.equal(decoded.seatNumber, '14B');
});

test('BundleService generates offline pre-flight bundle with aircraft and waypoints', () => {
  const sample = IataDecoderService.generateSamplePass({
    passengerName: 'MULLER/HANS MR',
    carrier: 'LH',
    flightDigits: '1420',
    origin: 'FRA',
    destination: 'OTP',
    seat: '08A',
  });

  const ticket = IataDecoderService.decode(sample);
  const bundle = BundleService.generateBundle(ticket);

  assert.ok(bundle.bundleVersion);
  assert.equal(bundle.flightRoute.flightNumber, 'LH1420');
  assert.equal(bundle.flightRoute.origin.iata, 'FRA');
  assert.equal(bundle.flightRoute.destination.iata, 'OTP');
  assert.ok(bundle.flightRoute.waypoints.length > 0);
  assert.ok(bundle.flightRoute.phaseSchedule.length > 0);
  assert.ok(bundle.soundboard.length > 0);
  assert.ok(bundle.panicScenarios.length > 0);
  assert.ok(bundle.bioRegulationConfig.boxBreathingPatternSec.length === 4);
});
