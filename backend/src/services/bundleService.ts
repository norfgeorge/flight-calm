import {
  IataBoardingPass,
  PreFlightBundle,
  FlightRouteProfile,
  Airport,
  Waypoint,
  FlightPhaseSchedule,
  AircraftProfile,
} from '../types/index.js';
import {
  AIRPORTS,
  AIRCRAFT_PROFILES,
  MECHANICAL_SOUNDS,
  PILOT_AUDIO_GUIDES,
  PANIC_SCENARIOS,
} from '../data/seedData.js';

export class BundleService {
  /**
   * Generates a complete self-contained offline pre-flight bundle (< 15 MB)
   * tailored to the passenger's specific flight ticket.
   */
  public static generateBundle(ticket: IataBoardingPass): PreFlightBundle {
    const origin = this.resolveAirport(ticket.originAirport, 'OTP');
    const destination = this.resolveAirport(ticket.destinationAirport, 'CDG');
    const aircraft = this.resolveAircraft(ticket.operatingCarrier, ticket.flightNumber);

    const distanceKm = this.calculateDistanceKm(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude
    );

    // Estimate flight duration (average groundspeed ~780 km/h + 25m taxi/takeoff/descent buffer)
    const flightMinutes = Math.max(45, Math.round((distanceKm / 780) * 60 + 25));

    // Generate route corridor waypoints
    const waypoints = this.generateWaypoints(origin, destination, flightMinutes);

    // Generate dead reckoning phase schedule
    const phaseSchedule = this.generatePhaseSchedule(flightMinutes, aircraft);

    // Filter relevant mechanical sounds for this aircraft
    const relevantSounds = MECHANICAL_SOUNDS.filter((sound) =>
      aircraft.mechanicalSoundIds.includes(sound.id)
    );

    const flightRoute: FlightRouteProfile = {
      flightNumber: ticket.flightNumber,
      operatingCarrier: ticket.operatingCarrier,
      carrierName: this.getCarrierName(ticket.operatingCarrier),
      origin,
      destination,
      scheduledDurationMinutes: flightMinutes,
      distanceKm: Math.round(distanceKm),
      aircraft,
      waypoints,
      phaseSchedule,
    };

    return {
      bundleVersion: '1.0.0',
      generatedAt: new Date().toISOString(),
      iataTicket: ticket,
      flightRoute,
      aircraft,
      soundboard: relevantSounds,
      pilotGuides: PILOT_AUDIO_GUIDES,
      panicScenarios: PANIC_SCENARIOS,
      bioRegulationConfig: {
        boxBreathingPatternSec: [4, 4, 4, 4], // Inhale 4s, Hold 4s, Exhale 4s, Hold 4s
        grounding54321PromptsRo: [
          'Find 5 objects in the cabin (e.g. edge of the tray table, front seat color, buckle, air vent nozzle, screen).',
          'Touch 4 different textures (e.g. your clothing fabric, cool metal buckle, armrest plastic, seat back).',
          'Listen closely for 3 distinct sounds (e.g. steady AC hum, muffled crew voices, soft cabin floor vibration).',
          'Identify 2 subtle scents (e.g. fresh galley coffee, mild cabin fragrance, or cool vent airflow).',
          'Focus on 1 grounding sensation (e.g. warmth of hands resting on your lap or firm floor support underfoot).',
        ],
      },
    };
  }

  private static resolveAirport(iataCode: string, fallbackCode: string): Airport {
    const code = iataCode?.toUpperCase();
    if (AIRPORTS[code]) {
      return AIRPORTS[code]!;
    }
    if (AIRPORTS[fallbackCode]) {
      return AIRPORTS[fallbackCode]!;
    }
    return {
      iata: code || 'UNKNOWN',
      icao: 'ZZZZ',
      name: `Aeroportul ${code}`,
      city: code,
      country: 'Internațional',
      latitude: 45.0,
      longitude: 25.0,
      elevationFt: 500,
    };
  }

  private static resolveAircraft(carrier: string, flightNumber: string): AircraftProfile {
    // Air France, Wizz Air, Lufthansa typically operate A320/A321neo on European routes
    if (carrier.startsWith('W6') || carrier.startsWith('AF') || carrier.startsWith('LH')) {
      return AIRCRAFT_PROFILES['A21N'] || AIRCRAFT_PROFILES['A320']!;
    }
    // Ryanair and TAROM typically operate Boeing 737-800
    if (carrier.startsWith('FR') || carrier.startsWith('RO')) {
      return AIRCRAFT_PROFILES['B738']!;
    }
    // Long-haul flights
    if (flightNumber.includes('101') || flightNumber.includes('885')) {
      return AIRCRAFT_PROFILES['B789'] || AIRCRAFT_PROFILES['A320']!;
    }
    return AIRCRAFT_PROFILES['A320']!;
  }

  private static getCarrierName(carrier: string): string {
    const map: Record<string, string> = {
      RO: 'TAROM',
      ROT: 'TAROM',
      LH: 'Lufthansa',
      DLH: 'Lufthansa',
      AF: 'Air France',
      AFR: 'Air France',
      W6: 'Wizz Air',
      WZZ: 'Wizz Air',
      FR: 'Ryanair',
      RYR: 'Ryanair',
      BA: 'British Airways',
      BAW: 'British Airways',
      DL: 'Delta Air Lines',
      KL: 'KLM Royal Dutch Airlines',
    };
    return map[carrier.toUpperCase()] || `Compania Aeriană ${carrier}`;
  }

  /**
   * Great-circle distance using Haversine formula
   */
  private static calculateDistanceKm(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
  ): number {
    const R = 6371; // Earth radius in km
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLon = ((lon2 - lon1) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  /**
   * Generates intermediate airway waypoints with simulated turbulence forecasting
   */
  private static generateWaypoints(
    origin: Airport,
    destination: Airport,
    durationMinutes: number
  ): Waypoint[] {
    const numWaypoints = 6;
    const waypoints: Waypoint[] = [];

    // Origin departure
    waypoints.push({
      name: `${origin.iata} Departure`,
      latitude: origin.latitude,
      longitude: origin.longitude,
      altitudeFt: origin.elevationFt,
      estimatedMinutesFromDeparture: 0,
      turbulenceSeverity: 'smooth',
      turbulenceDescription: 'Condiții calme la sol și decolare.',
    });

    for (let i = 1; i <= numWaypoints; i++) {
      const frac = i / (numWaypoints + 1);
      const lat = origin.latitude + (destination.latitude - origin.latitude) * frac;
      const lon = origin.longitude + (destination.longitude - origin.longitude) * frac;
      const timeMin = Math.round(durationMinutes * frac);

      let alt = 36000;
      let severity: 'smooth' | 'light_chop' | 'moderate' = 'smooth';
      let desc = 'Flux aerian laminat stabil, zbor confortabil.';

      if (frac < 0.25) {
        alt = Math.round(origin.elevationFt + (36000 - origin.elevationFt) * (frac / 0.25));
        desc = 'Urcare inițială spre altitudinea de croazieră.';
      } else if (frac > 0.75) {
        alt = Math.round(36000 - (36000 - destination.elevationFt) * ((frac - 0.75) / 0.25));
        desc = 'Coborâre treptată (Top of Descent) către destinație.';
      } else if (i === 3) {
        // Introduce a typical light chop waypoint over mountainous or jetstream areas
        severity = 'light_chop';
        desc = 'Ușoară zonă de curenți termici (trepidații ușoare sub 0.15G).';
      }

      waypoints.push({
        name: `WP-${i}`,
        latitude: parseFloat(lat.toFixed(4)),
        longitude: parseFloat(lon.toFixed(4)),
        altitudeFt: alt,
        estimatedMinutesFromDeparture: timeMin,
        turbulenceSeverity: severity,
        turbulenceDescription: desc,
      });
    }

    // Destination arrival
    waypoints.push({
      name: `${destination.iata} Arrival`,
      latitude: destination.latitude,
      longitude: destination.longitude,
      altitudeFt: destination.elevationFt,
      estimatedMinutesFromDeparture: durationMinutes,
      turbulenceSeverity: 'smooth',
      turbulenceDescription: 'Apropiere finală și aterizare stabilă.',
    });

    return waypoints;
  }

  /**
   * Generates dead-reckoning timeline phases
   */
  private static generatePhaseSchedule(
    totalMinutes: number,
    aircraft: AircraftProfile
  ): FlightPhaseSchedule[] {
    const taxiOutEnd = 12;
    const takeoffEnd = 16;
    const climbEnd = Math.min(38, Math.round(totalMinutes * 0.22));
    const descentStart = Math.max(climbEnd + 15, totalMinutes - 28);
    const approachStart = totalMinutes - 10;

    return [
      {
        phase: 'pre_flight',
        startMinute: 0,
        endMinute: 5,
        expectedCabinAltitudeFt: 300,
        pilotDescription:
          'Îmbarcare la poartă, verificări pre-zbor și închiderea ușilor. Sistemul de aer condiționat ventilează cabina.',
      },
      {
        phase: 'taxi',
        startMinute: 5,
        endMinute: taxiOutEnd,
        expectedCabinAltitudeFt: 300,
        pilotDescription:
          'Rulare către pistă. Se testează flapsurile și sistemele hidraulice (inclusiv PTU dacă zbori cu Airbus).',
      },
      {
        phase: 'takeoff',
        startMinute: taxiOutEnd,
        endMinute: takeoffEnd,
        expectedCabinAltitudeFt: 1000,
        pilotDescription:
          'Tracțiune maximă pe pistă și desprindere. Roțile se retrag sub podea cu un pocnet mecanic ferm.',
      },
      {
        phase: 'climb',
        startMinute: takeoffEnd,
        endMinute: climbEnd,
        expectedCabinAltitudeFt: 4500,
        pilotDescription:
          'Reducerea puterii la tracțiune de urcare la 1.000m. Avionul urcă lin spre altitudinea de croazieră.',
      },
      {
        phase: 'cruise',
        startMinute: climbEnd,
        endMinute: descentStart,
        expectedCabinAltitudeFt: aircraft.cabinAltitudeAtCruiseFt,
        pilotDescription:
          'Zbor de croazieră orizontal stabil. Presiunea din cabină este menținută constantă de computerele de bord.',
      },
      {
        phase: 'descent',
        startMinute: descentStart,
        endMinute: approachStart,
        expectedCabinAltitudeFt: 4000,
        pilotDescription:
          'Începerea coborârii (Top of Descent). Presiunea din cabină începe să crească treptat spre nivelul solului.',
      },
      {
        phase: 'approach',
        startMinute: approachStart,
        endMinute: totalMinutes,
        expectedCabinAltitudeFt: 1500,
        pilotDescription:
          'Extinderea flapsurilor și a trenului de aterizare. Aliniere pe axul pistei și atingere lină a roților.',
      },
      {
        phase: 'landed',
        startMinute: totalMinutes,
        endMinute: totalMinutes + 8,
        expectedCabinAltitudeFt: 300,
        pilotDescription:
          'Inversorii de tracțiune frânează aeronava, urmat de rularea către terminal și debarcare.',
      },
    ];
  }
}
