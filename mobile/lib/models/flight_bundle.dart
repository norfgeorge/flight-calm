import 'boarding_pass.dart';

class AirportInfo {
  final String iata;
  final String name;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int elevationFt;

  AirportInfo({
    required this.iata,
    required this.name,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.elevationFt,
  });

  factory AirportInfo.fromJson(Map<String, dynamic> json) {
    return AirportInfo(
      iata: json['iata'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      elevationFt: json['elevationFt'] ?? 0,
    );
  }
}

class AircraftInfo {
  final String icao;
  final String name;
  final String manufacturer;
  final String family;
  final double wingspanMeters;
  final double maxWingFlexMeters;
  final int typicalCruisingAltitudeFt;
  final int cabinAltitudeAtCruiseFt;
  final bool hasCompositeFuselage;
  final int accelerationAltitudeFt;
  final int climbThrustCutbackDurationSec;
  final bool hasPtuBark;
  final List<String> mechanicalSoundIds;

  AircraftInfo({
    required this.icao,
    required this.name,
    required this.manufacturer,
    required this.family,
    required this.wingspanMeters,
    required this.maxWingFlexMeters,
    required this.typicalCruisingAltitudeFt,
    required this.cabinAltitudeAtCruiseFt,
    required this.hasCompositeFuselage,
    required this.accelerationAltitudeFt,
    required this.climbThrustCutbackDurationSec,
    required this.hasPtuBark,
    required this.mechanicalSoundIds,
  });

  factory AircraftInfo.fromJson(Map<String, dynamic> json) {
    final acoustic = json['acousticProfile'] ?? {};
    return AircraftInfo(
      icao: json['icao'] ?? 'A320',
      name: json['name'] ?? 'Airbus A320',
      manufacturer: json['manufacturer'] ?? 'Airbus',
      family: json['family'] ?? 'Airbus A320 Family',
      wingspanMeters: (json['wingspanMeters'] as num?)?.toDouble() ?? 35.8,
      maxWingFlexMeters: (json['maxWingFlexMeters'] as num?)?.toDouble() ?? 2.8,
      typicalCruisingAltitudeFt: json['typicalCruisingAltitudeFt'] ?? 37000,
      cabinAltitudeAtCruiseFt: json['cabinAltitudeAtCruiseFt'] ?? 7800,
      hasCompositeFuselage: json['hasCompositeFuselage'] ?? false,
      accelerationAltitudeFt: json['accelerationAltitudeFt'] ?? 3000,
      climbThrustCutbackDurationSec: json['climbThrustCutbackDurationSec'] ?? 210,
      hasPtuBark: acoustic['hasPtuBark'] ?? true,
      mechanicalSoundIds: List<String>.from(json['mechanicalSoundIds'] ?? []),
    );
  }
}

class FlightPhase {
  final String phase;
  final int startMinute;
  final int endMinute;
  final int expectedCabinAltitudeFt;
  final String pilotDescription;

  FlightPhase({
    required this.phase,
    required this.startMinute,
    required this.endMinute,
    required this.expectedCabinAltitudeFt,
    required this.pilotDescription,
  });

  factory FlightPhase.fromJson(Map<String, dynamic> json) {
    return FlightPhase(
      phase: json['phase'] ?? 'cruise',
      startMinute: json['startMinute'] ?? 0,
      endMinute: json['endMinute'] ?? 60,
      expectedCabinAltitudeFt: json['expectedCabinAltitudeFt'] ?? 7000,
      pilotDescription: json['pilotDescription'] ?? '',
    );
  }
}

class MechanicalSoundItem {
  final String id;
  final String name;
  final String titleRo;
  final String category;
  final String aircraftFamily;
  final String triggerFlightPhase;
  final String descriptionRo;
  final String pilotExplanationRo;
  final int audioDurationSec;
  final String audioFileName;

  MechanicalSoundItem({
    required this.id,
    required this.name,
    required this.titleRo,
    required this.category,
    required this.aircraftFamily,
    required this.triggerFlightPhase,
    required this.descriptionRo,
    required this.pilotExplanationRo,
    required this.audioDurationSec,
    required this.audioFileName,
  });

  factory MechanicalSoundItem.fromJson(Map<String, dynamic> json) {
    return MechanicalSoundItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      titleRo: json['titleRo'] ?? '',
      category: json['category'] ?? '',
      aircraftFamily: json['aircraftFamily'] ?? '',
      triggerFlightPhase: json['triggerFlightPhase'] ?? 'ground',
      descriptionRo: json['descriptionRo'] ?? '',
      pilotExplanationRo: json['pilotExplanationRo'] ?? '',
      audioDurationSec: json['audioDurationSec'] ?? 10,
      audioFileName: json['audioFileName'] ?? '',
    );
  }
}

class PanicScenarioItem {
  final String id;
  final String prompt;
  final String category;
  final String baseResponse;
  final String? telemetryTemplate;

  // Backward-compatibility getters
  String get promptRo => prompt;
  String get baseResponseRo => baseResponse;
  String? get telemetryTemplateRo => telemetryTemplate;

  PanicScenarioItem({
    required this.id,
    required this.prompt,
    required this.category,
    required this.baseResponse,
    this.telemetryTemplate,
  });

  factory PanicScenarioItem.fromJson(Map<String, dynamic> json) {
    return PanicScenarioItem(
      id: json['id'] ?? '',
      prompt: json['prompt'] ?? json['promptRo'] ?? '',
      category: json['category'] ?? 'general',
      baseResponse: json['baseResponse'] ?? json['baseResponseRo'] ?? '',
      telemetryTemplate: json['telemetryTemplate'] ?? json['telemetryTemplateRo'],
    );
  }

  String getCalibratedResponse({
    int minuteFromTakeoff = 4,
    int altitudeFt = 3200,
    double deltaG = 0.12,
    double bankAngle = 22.0,
  }) {
    final template = telemetryTemplate ?? baseResponse;
    return template
        .replaceAll('{minuteFromTakeoff}', minuteFromTakeoff.toString())
        .replaceAll('{altitudeFt}', altitudeFt.toString())
        .replaceAll('{deltaG}', deltaG.toStringAsFixed(2))
        .replaceAll('{bankAngle}', bankAngle.toStringAsFixed(0));
  }
}

class PreFlightBundleData {
  final String bundleVersion;
  final String generatedAt;
  final BoardingPass iataTicket;
  final AirportInfo origin;
  final AirportInfo destination;
  final String carrierName;
  final int scheduledDurationMinutes;
  final int distanceKm;
  final AircraftInfo aircraft;
  final List<FlightPhase> phases;
  final List<MechanicalSoundItem> soundboard;
  final List<PanicScenarioItem> panicScenarios;
  final List<String> groundingPrompts;

  PreFlightBundleData({
    required this.bundleVersion,
    required this.generatedAt,
    required this.iataTicket,
    required this.origin,
    required this.destination,
    required this.carrierName,
    required this.scheduledDurationMinutes,
    required this.distanceKm,
    required this.aircraft,
    required this.phases,
    required this.soundboard,
    required this.panicScenarios,
    required this.groundingPrompts,
  });

  factory PreFlightBundleData.fromJson(Map<String, dynamic> json) {
    final route = json['flightRoute'] ?? {};
    final bio = json['bioRegulationConfig'] ?? {};

    return PreFlightBundleData(
      bundleVersion: json['bundleVersion'] ?? '1.0.0',
      generatedAt: json['generatedAt'] ?? '',
      iataTicket: BoardingPass.fromJson(json['iataTicket'] ?? {}),
      origin: AirportInfo.fromJson(route['origin'] ?? {}),
      destination: AirportInfo.fromJson(route['destination'] ?? {}),
      carrierName: route['carrierName'] ?? 'Airline',
      scheduledDurationMinutes: route['scheduledDurationMinutes'] ?? 120,
      distanceKm: route['distanceKm'] ?? 1000,
      aircraft: AircraftInfo.fromJson(json['aircraft'] ?? {}),
      phases: (route['phaseSchedule'] as List? ?? [])
          .map((p) => FlightPhase.fromJson(p))
          .toList(),
      soundboard: (json['soundboard'] as List? ?? [])
          .map((s) => MechanicalSoundItem.fromJson(s))
          .toList(),
      panicScenarios: (json['panicScenarios'] as List? ?? [])
          .map((q) => PanicScenarioItem.fromJson(q))
          .toList(),
      groundingPrompts: List<String>.from(bio['groundingPrompts'] ?? bio['grounding54321PromptsRo'] ?? []),
    );
  }
}
