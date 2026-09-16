import {
  Airport,
  AircraftProfile,
  MechanicalSound,
  PilotAudioGuide,
  PanicQnA,
} from '../types/index.js';

export const AIRPORTS: Record<string, Airport> = {
  OTP: {
    iata: 'OTP',
    icao: 'LROP',
    name: 'Henri Coandă International Airport',
    city: 'Bucharest',
    country: 'Romania',
    latitude: 44.5711,
    longitude: 26.085,
    elevationFt: 314,
  },
  CDG: {
    iata: 'CDG',
    icao: 'LFPG',
    name: 'Paris Charles de Gaulle Airport',
    city: 'Paris',
    country: 'France',
    latitude: 49.0097,
    longitude: 2.5479,
    elevationFt: 392,
  },
  MUC: {
    iata: 'MUC',
    icao: 'EDDM',
    name: 'Munich Franz Josef Strauss Airport',
    city: 'Munich',
    country: 'Germany',
    latitude: 48.3538,
    longitude: 11.7861,
    elevationFt: 1487,
  },
  FRA: {
    iata: 'FRA',
    icao: 'EDDF',
    name: 'Frankfurt Airport',
    city: 'Frankfurt',
    country: 'Germany',
    latitude: 50.0379,
    longitude: 8.5622,
    elevationFt: 364,
  },
  LHR: {
    iata: 'LHR',
    icao: 'EGLL',
    name: 'London Heathrow Airport',
    city: 'London',
    country: 'United Kingdom',
    latitude: 51.4700,
    longitude: -0.4543,
    elevationFt: 83,
  },
  JFK: {
    iata: 'JFK',
    icao: 'KJFK',
    name: 'John F. Kennedy International Airport',
    city: 'New York',
    country: 'United States',
    latitude: 40.6413,
    longitude: -73.7781,
    elevationFt: 13,
  },
  AMS: {
    iata: 'AMS',
    icao: 'EHAM',
    name: 'Amsterdam Airport Schiphol',
    city: 'Amsterdam',
    country: 'Netherlands',
    latitude: 52.3105,
    longitude: 4.7683,
    elevationFt: -11,
  },
};

export const AIRCRAFT_PROFILES: Record<string, AircraftProfile> = {
  A320: {
    icao: 'A320',
    name: 'Airbus A320-200',
    manufacturer: 'Airbus',
    family: 'Airbus A320 Family',
    wingspanMeters: 35.8,
    maxWingFlexMeters: 2.8,
    typicalCruisingAltitudeFt: 37000,
    typicalCruiseSpeedKnots: 450,
    cabinAltitudeAtCruiseFt: 7800,
    hasCompositeFuselage: false,
    accelerationAltitudeFt: 3000,
    climbThrustCutbackDurationSec: 210,
    acousticProfile: {
      engineWhineHz: 480,
      cabinNoiseDbAvg: 74,
      hasPtuBark: true,
      gearExtensionSoundProfile: 'heavy_thud_air_roar',
    },
    mechanicalSoundIds: ['airbus_ptu', 'gear_down', 'flaps_extension', 'packs_air', 'reverse_thrust'],
  },
  A21N: {
    icao: 'A21N',
    name: 'Airbus A321neo',
    manufacturer: 'Airbus',
    family: 'Airbus A320 Family',
    wingspanMeters: 35.8,
    maxWingFlexMeters: 3.1,
    typicalCruisingAltitudeFt: 38000,
    typicalCruiseSpeedKnots: 455,
    cabinAltitudeAtCruiseFt: 7600,
    hasCompositeFuselage: false,
    accelerationAltitudeFt: 3000,
    climbThrustCutbackDurationSec: 220,
    acousticProfile: {
      engineWhineHz: 420,
      cabinNoiseDbAvg: 70,
      hasPtuBark: true,
      gearExtensionSoundProfile: 'damped_thud_air_roar',
    },
    mechanicalSoundIds: ['airbus_ptu', 'gear_down', 'flaps_extension', 'packs_air', 'reverse_thrust'],
  },
  B738: {
    icao: 'B738',
    name: 'Boeing 737-800 Next-Gen',
    manufacturer: 'Boeing',
    family: 'Boeing 737 Family',
    wingspanMeters: 35.8,
    maxWingFlexMeters: 2.5,
    typicalCruisingAltitudeFt: 36000,
    typicalCruiseSpeedKnots: 450,
    cabinAltitudeAtCruiseFt: 8000,
    hasCompositeFuselage: false,
    accelerationAltitudeFt: 2500,
    climbThrustCutbackDurationSec: 190,
    acousticProfile: {
      engineWhineHz: 510,
      cabinNoiseDbAvg: 76,
      hasPtuBark: false,
      gearExtensionSoundProfile: 'mechanical_clunk_hydraulic',
    },
    mechanicalSoundIds: ['gear_down', 'flaps_extension', 'packs_air', 'reverse_thrust', 'spoilers_rumble'],
  },
  B789: {
    icao: 'B789',
    name: 'Boeing 787-9 Dreamliner',
    manufacturer: 'Boeing',
    family: 'Boeing 787 Dreamliner',
    wingspanMeters: 60.1,
    maxWingFlexMeters: 5.2,
    typicalCruisingAltitudeFt: 41000,
    typicalCruiseSpeedKnots: 490,
    cabinAltitudeAtCruiseFt: 6000,
    hasCompositeFuselage: true,
    accelerationAltitudeFt: 3000,
    climbThrustCutbackDurationSec: 240,
    acousticProfile: {
      engineWhineHz: 350,
      cabinNoiseDbAvg: 67,
      hasPtuBark: false,
      gearExtensionSoundProfile: 'smooth_hydraulic_aerodynamic',
    },
    mechanicalSoundIds: ['gear_down', 'flaps_extension', 'packs_air', 'reverse_thrust', 'spoilers_rumble'],
  },
};

export const MECHANICAL_SOUNDS: MechanicalSound[] = [
  {
    id: 'airbus_ptu',
    name: 'Airbus Hydraulic PTU Bark',
    titleRo: 'Airbus Hydraulic PTU Bark',
    category: 'hydraulics',
    aircraftFamily: 'Airbus A320 / A321 / A330',
    triggerFlightPhase: 'ground',
    descriptionRo:
      'A rhythmic mechanical sound like a bark or mechanical saw heard on the ground during taxi or parking.',
    pilotExplanationRo:
      'The Power Transfer Unit (PTU) is a safety transfer pump. If one engine is shut down on the ground to save fuel, the PTU safely transfers hydraulic pressure between circuits without mixing fluid. It proves hydraulic redundancy is active.',
    audioDurationSec: 14,
    audioFileName: 'airbus_ptu_bark.opus',
  },
  {
    id: 'gear_down',
    name: 'Landing Gear Deployment & Lock',
    titleRo: 'Landing Gear Extension & Lock',
    category: 'landing_gear',
    aircraftFamily: 'All commercial aircraft',
    triggerFlightPhase: 'descent',
    descriptionRo:
      'A dull mechanical thud beneath the floor, followed by wind rush and mild vibration through your seat.',
    pilotExplanationRo:
      'At around 6,000 feet, 5 to 8 minutes prior to landing, we open the gear doors and extend the wheels. The whoosh is 300 km/h wind resistance, and the thud is the heavy-duty mechanical down-lock securing the wheels.',
    audioDurationSec: 18,
    audioFileName: 'landing_gear_deploy.opus',
  },
  {
    id: 'flaps_extension',
    name: 'Flaps and Slats Motor Whine',
    titleRo: 'Flaps and Slats Motor Whine',
    category: 'flaps_slats',
    aircraftFamily: 'All commercial aircraft',
    triggerFlightPhase: 'descent',
    descriptionRo:
      'A high-pitched electric motor sound from the wings lasting 10 to 15 seconds.',
    pilotExplanationRo:
      'To allow smooth and gentle landings at slower speeds, electric and hydraulic actuators extend the flaps along the trailing edge. The wing increases in surface area and generates maximum lift at safe approach speeds.',
    audioDurationSec: 12,
    audioFileName: 'flaps_extension.opus',
  },
  {
    id: 'reverse_thrust',
    name: 'Thrust Reversers on Touchdown',
    titleRo: 'Thrust Reversers on Touchdown',
    category: 'engines',
    aircraftFamily: 'All commercial aircraft',
    triggerFlightPhase: 'landing',
    descriptionRo:
      'Immediately after the main wheels touch the tarmac, engines briefly roar at higher RPM for 10 to 15 seconds.',
    pilotExplanationRo:
      'Engine side cowlings open and deflect bypass airflow forward. Instead of pushing the plane, the engines act as a massive aerodynamic brake, absorbing up to 70% of kinetic rollout energy and easing wheel brake pads.',
    audioDurationSec: 16,
    audioFileName: 'reverse_thrust.opus',
  },
  {
    id: 'spoilers_rumble',
    name: 'Flight Spoilers Aerodynamic Rumble',
    titleRo: 'Flight Spoilers Aerodynamic Rumble',
    category: 'cabin_pressurization',
    aircraftFamily: 'All commercial aircraft',
    triggerFlightPhase: 'descent',
    descriptionRo:
      'A continuous low-frequency rumble and wind rush during descent from cruise altitude.',
    pilotExplanationRo:
      'Pilots raise metal panels on top of the wings (spoilers) to gently disrupt lift and descend smoothly without exceeding speed limits. The vibration is purely aerodynamic and routine.',
    audioDurationSec: 15,
    audioFileName: 'spoilers_rumble.opus',
  },
];

export const PILOT_AUDIO_GUIDES: PilotAudioGuide[] = [
  {
    id: 'guide_redundancy',
    titleRo: 'Why an Aircraft Never Loses Controls: Triple Redundancy',
    category: 'redundancy',
    durationSec: 180,
    pilotName: 'Captain Alexandru M.',
    audioFileName: 'guide_redundancy.opus',
    summaryRo:
      'Every vital cockpit system has 2 or 3 independent backups: 3 separate hydraulic circuits, dedicated engine generators, auxiliary power unit (APU), and emergency ram air turbine (RAT).',
    keyTakeawaysRo: [
      'If any single system fails, backup systems engage in milliseconds.',
      'Electrical generators operate independently on each engine.',
      'Flight control computers run on separated electrical buses.',
    ],
  },
  {
    id: 'guide_wings_flex',
    titleRo: 'Why Wings Flex Like Springs and Cannot Break',
    category: 'aerodynamics',
    durationSec: 210,
    pilotName: 'Captain Alexandru M.',
    audioFileName: 'guide_wings_flex.opus',
    summaryRo:
      'Wings are deliberately engineered to flex, like a deep-sea fishing rod. Flexing absorbs turbulence energy smoothly. In factory stress tests, wings are flexed past 5 meters upward before any structural damage.',
    keyTakeawaysRo: [
      'Flexibility is a key structural safety design, not a weakness.',
      'Wing flexing dampens bumps before they reach the cabin.',
      'Atmospheric turbulence lacks the physical force required to break a commercial wing.',
    ],
  },
  {
    id: 'guide_engine_out',
    titleRo: 'What Happens If an Engine Fails in Flight',
    category: 'cockpit_procedures',
    durationSec: 195,
    pilotName: 'Captain Alexandru M.',
    audioFileName: 'guide_engine_out.opus',
    summaryRo:
      'Twin-engine passenger jets are certified to take off, climb, and cruise safely for up to 5 hours on a single engine (ETOPS certification). Airline captains practice single-engine procedures in the simulator every 6 months.',
    keyTakeawaysRo: [
      'Twin-engine aircraft maintain stable flight and climb on one engine.',
      'Gliding range without engines exceeds 100 kilometers (15:1 glide ratio).',
      'Every recovery procedure is thoroughly practiced and automated.',
    ],
  },
];

export const PANIC_SCENARIOS: PanicQnA[] = [
  {
    id: 'thrust_reduction',
    promptRo: 'Why did the engines suddenly quiet down after takeoff?',
    category: 'thrust',
    sensorCrossReference: {
      requiresBarometer: true,
      requiresAccelerometer: false,
      requiresFlightTimeline: true,
    },
    baseResponseRo:
      'The engines did not shut down. We simply reached acceleration altitude (~3,000 feet). Pilots reduced thrust from maximum takeoff power to standard continuous climb power. This is standard on every commercial flight in the world.',
    telemetryTemplateRo:
      'We are at minute {minuteFromTakeoff} after takeoff, at ~{altitudeFt} ft cabin altitude. The sound drop you noticed is the routine transition to quiet climb thrust.',
  },
  {
    id: 'sudden_jolt',
    promptRo: 'What was that sudden bump or shudder?',
    category: 'turbulence',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: true,
      requiresFlightTimeline: false,
    },
    baseResponseRo:
      'The aircraft flew through a pocket of air with slightly different density or a mild thermal updraft. The sensors show minimal acceleration. Wings are built to absorb forces 20 times stronger with complete structural safety.',
    telemetryTemplateRo:
      'We recorded a vertical variance of only {deltaG} G over the last 15 seconds. Driving over a highway expansion joint produces 0.35 G. The aircraft is on a 100% stable track.',
  },
  {
    id: 'steep_turn',
    promptRo: 'Why is the airplane banking so steeply?',
    category: 'bank_angle',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: true,
      requiresFlightTimeline: false,
    },
    baseResponseRo:
      'The aircraft is following our ATC airway corridor. Commercial turns bank only 15 to 25 degrees, but inner ear sensors exaggerate the angle without visual ground references. The aircraft cannot slip sideways.',
    telemetryTemplateRo:
      'Current bank angle is {bankAngle} degrees. Centrifugal force holds passengers and cups securely in place.',
  },
  {
    id: 'cabin_lights_dim',
    promptRo: 'Why were the cabin lights dimmed?',
    category: 'lights',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: false,
      requiresFlightTimeline: true,
    },
    baseResponseRo:
      'At night or dusk, cabin lights are dimmed before takeoff and landing to allow eyes to adapt to darkness in the unlikely event of an evacuation. It is a universal global safety protocol.',
  },
  {
    id: 'turbulence_safety',
    promptRo: 'Can turbulence flip or break an airplane?',
    category: 'turbulence',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: true,
      requiresFlightTimeline: false,
    },
    baseResponseRo:
      'No commercial airliner in modern aviation has ever been flipped or broken by turbulence. Wings are built from hyper-flexible aerospace alloys engineered to bend over 5 meters (15 feet) and endure forces far beyond anything nature can produce.',
  },
  {
    id: 'sudden_drop',
    promptRo: 'Why did the plane suddenly feel like it dropped?',
    category: 'turbulence',
    sensorCrossReference: {
      requiresBarometer: true,
      requiresAccelerometer: true,
      requiresFlightTimeline: false,
    },
    baseResponseRo:
      'You crossed a small thermal updraft or downdraft. While your inner ear exaggerates the sensation to feel like a huge drop, flight telemetry data shows the aircraft actually moves vertically less than 2 to 3 feet.',
  },
  {
    id: 'holding_pattern',
    promptRo: 'Why are we circling in a loop in the air?',
    category: 'thrust',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: false,
      requiresFlightTimeline: true,
    },
    baseResponseRo:
      'This is a standard holding pattern. Air Traffic Control holds aircraft in structured racetrack loops to sequence landings smoothly or allow weather to pass. We carry 45+ minutes of mandatory reserve fuel specifically for this.',
  },
  {
    id: 'engine_failure',
    promptRo: 'What happens if an engine stops working?',
    category: 'safety',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: false,
      requiresFlightTimeline: false,
    },
    baseResponseRo:
      'Twin-engine airliners are certified under ETOPS regulations to climb, cruise, and land completely normally on just one engine. Even if all power were idle, the airplane glides smoothly for over 80 miles, easily reaching diversion airports.',
  },
  {
    id: 'ac_mist',
    promptRo: 'Why is there white mist coming from overhead vents?',
    category: 'safety',
    sensorCrossReference: {
      requiresBarometer: false,
      requiresAccelerometer: false,
      requiresFlightTimeline: true,
    },
    baseResponseRo:
      'That is 100% harmless water vapor—identical to seeing your breath on a cold morning. Air conditioning cooling warm cabin air condenses moisture into visible mist. It is odorless, non-toxic, and disappears in seconds.',
  },
];
