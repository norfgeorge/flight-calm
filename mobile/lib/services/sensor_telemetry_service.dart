import 'dart:async';
import 'dart:math';

class TelemetrySnapshot {
  final double deltaG; // Vertical G-force deviation (e.g. 0.08G, 0.15G)
  final double filteredAccelZ; // Normalized filtered Z-acceleration
  final double bankAngleDeg; // Aircraft bank angle in degrees
  final bool isTurbulence;
  final String statusTextRo;

  TelemetrySnapshot({
    required this.deltaG,
    required this.filteredAccelZ,
    required this.bankAngleDeg,
    required this.isTurbulence,
    required this.statusTextRo,
  });
}

class SensorTelemetryService {
  // Low-pass filter smoothing coefficient (alpha ~ 0.15 for cutoff ~2 Hz at 50Hz sample rate)
  final double _alpha = 0.18;

  double _filteredX = 0.0;
  double _filteredY = 0.0;
  double _filteredZ = 9.81;

  final StreamController<TelemetrySnapshot> _telemetryController =
      StreamController<TelemetrySnapshot>.broadcast();

  Stream<TelemetrySnapshot> get telemetryStream => _telemetryController.stream;
  TelemetrySnapshot _lastSnapshot = TelemetrySnapshot(
    deltaG: 0.02,
    filteredAccelZ: 1.0,
    bankAngleDeg: 0.0,
    isTurbulence: false,
    statusTextRo: 'Stable & nominal flight',
  );

  TelemetrySnapshot get currentSnapshot => _lastSnapshot;

  void processRawSensorData(double rawX, double rawY, double rawZ) {
    // 1. Digital low-pass filter to eliminate user's hand tremors
    _filteredX = _alpha * rawX + (1 - _alpha) * _filteredX;
    _filteredY = _alpha * rawY + (1 - _alpha) * _filteredY;
    _filteredZ = _alpha * rawZ + (1 - _alpha) * _filteredZ;

    // 2. Magnitude in m/s^2 converted to G-units (1G = 9.80665 m/s^2)
    final totalG = sqrt(_filteredX * _filteredX + _filteredY * _filteredY + _filteredZ * _filteredZ) / 9.80665;
    final deltaG = (totalG - 1.0).abs();

    // 3. Bank angle (roll) calculation
    final bankAngle = (atan2(_filteredX, _filteredZ) * (180.0 / pi)).abs();

    // 4. Status determination
    String status = 'Smooth & comfortable flight';
    bool isTurb = false;

    if (deltaG > 0.25) {
      status = 'Moderate gust (Wings absorbing shock)';
      isTurb = true;
    } else if (deltaG > 0.08) {
      status = 'Light atmospheric ripple';
      isTurb = true;
    }

    _lastSnapshot = TelemetrySnapshot(
      deltaG: double.parse(deltaG.toStringAsFixed(2)),
      filteredAccelZ: double.parse(totalG.toStringAsFixed(2)),
      bankAngleDeg: double.parse(bankAngle.toStringAsFixed(1)),
      isTurbulence: isTurb,
      statusTextRo: status,
    );

    _telemetryController.add(_lastSnapshot);
  }

  void dispose() {
    _telemetryController.close();
  }
}
