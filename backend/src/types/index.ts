export interface IataBoardingPass {
  rawBarcode: string;
  formatCode: string;
  numberOfLegs: number;
  passengerName: string;
  pnr: string;
  originAirport: string;
  destinationAirport: string;
  operatingCarrier: string;
  flightNumber: string;
  julianDate: number;
  compartmentCode: string;
  seatNumber: string;
  checkinSequence: string;
  passengerStatus?: string;
  flightDateFormatted?: string;
}

export interface Airport {
  iata: string;
  icao: string;
  name: string;
  city: string;
  country: string;
  latitude: number;
  longitude: number;
  elevationFt: number;
}

export interface AircraftProfile {
  icao: string;
  name: string;
  manufacturer: 'Airbus' | 'Boeing' | 'Embraer';
  family: string;
  wingspanMeters: number;
  maxWingFlexMeters: number;
  typicalCruisingAltitudeFt: number;
  typicalCruiseSpeedKnots: number;
  cabinAltitudeAtCruiseFt: number;
  hasCompositeFuselage: boolean; // e.g. B787, A350 have 6000ft cabin altitude vs 8000ft
  accelerationAltitudeFt: number; // typically 1000 - 3000 ft AGL where thrust is reduced
  climbThrustCutbackDurationSec: number; // typically 180 - 240 sec post-takeoff
  acousticProfile: {
    engineWhineHz: number;
    cabinNoiseDbAvg: number;
    hasPtuBark: boolean;
    gearExtensionSoundProfile: string;
  };
  mechanicalSoundIds: string[];
}

export interface Waypoint {
  name: string;
  latitude: number;
  longitude: number;
  altitudeFt: number;
  estimatedMinutesFromDeparture: number;
  turbulenceSeverity: 'smooth' | 'light_chop' | 'moderate';
  turbulenceDescription?: string;
}

export interface FlightPhaseSchedule {
  phase: 'pre_flight' | 'taxi' | 'takeoff' | 'climb' | 'cruise' | 'descent' | 'approach' | 'landed';
  startMinute: number;
  endMinute: number;
  expectedCabinAltitudeFt: number;
  pilotDescription: string;
}

export interface FlightRouteProfile {
  flightNumber: string;
  operatingCarrier: string;
  carrierName: string;
  origin: Airport;
  destination: Airport;
  scheduledDurationMinutes: number;
  distanceKm: number;
  aircraft: AircraftProfile;
  waypoints: Waypoint[];
  phaseSchedule: FlightPhaseSchedule[];
}

export interface MechanicalSound {
  id: string;
  name: string;
  titleRo: string;
  category: 'hydraulics' | 'landing_gear' | 'flaps_slats' | 'engines' | 'cabin_pressurization';
  aircraftFamily: string;
  triggerFlightPhase: 'ground' | 'takeoff' | 'cruise' | 'descent' | 'landing';
  descriptionRo: string;
  pilotExplanationRo: string;
  audioDurationSec: number;
  audioFileName: string;
}

export interface PilotAudioGuide {
  id: string;
  titleRo: string;
  category: 'aerodynamics' | 'redundancy' | 'weather' | 'cockpit_procedures';
  durationSec: number;
  pilotName: string;
  audioFileName: string;
  summaryRo: string;
  keyTakeawaysRo: string[];
}

export interface PanicQnA {
  id: string;
  promptRo: string;
  category: 'thrust' | 'turbulence' | 'bank_angle' | 'noises' | 'lights' | 'pressure' | 'safety';
  sensorCrossReference: {
    requiresBarometer: boolean;
    requiresAccelerometer: boolean;
    requiresFlightTimeline: boolean;
  };
  baseResponseRo: string;
  telemetryTemplateRo?: string; // e.g. "Am înregistrat o variație de {deltaG} G..."
}

export interface PreFlightBundle {
  bundleVersion: string;
  generatedAt: string;
  iataTicket: IataBoardingPass;
  flightRoute: FlightRouteProfile;
  aircraft: AircraftProfile;
  soundboard: MechanicalSound[];
  pilotGuides: PilotAudioGuide[];
  panicScenarios: PanicQnA[];
  bioRegulationConfig: {
    boxBreathingPatternSec: [number, number, number, number]; // inhale, hold, exhale, hold
    grounding54321PromptsRo: string[];
  };
}
