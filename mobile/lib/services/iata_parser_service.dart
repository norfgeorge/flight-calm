import '../models/boarding_pass.dart';

class IataParserService {
  static BoardingPass decode(String rawBarcode) {
    final trimmed = rawBarcode.trim();
    if (trimmed.length < 50) {
      throw FormatException('Cod de bare IATA invalid sau prea scurt.');
    }

    final formatCode = trimmed.substring(0, 1);
    final numberOfLegs = int.tryParse(trimmed.substring(1, 2)) ?? 1;

    final rawName = trimmed.substring(2, 22).trim();
    final passengerName = _formatPassengerName(rawName);

    final pnr = trimmed.substring(23, 30).trim();
    final originAirport = trimmed.substring(30, 33).trim().toUpperCase();
    final destinationAirport = trimmed.substring(33, 36).trim().toUpperCase();
    final operatingCarrier = trimmed.substring(36, 39).trim().toUpperCase();

    final rawFlightNumber = trimmed.substring(39, 44).trim();
    final flightDigits = rawFlightNumber.replaceFirst(RegExp(r'^0+'), '');
    final flightNumber = '$operatingCarrier$flightDigits';

    final julianDate = int.tryParse(trimmed.substring(44, 47).trim()) ?? 258;
    final compartmentCode = trimmed.length > 47 ? trimmed.substring(47, 48).trim() : 'Y';
    final seatNumber = trimmed.length >= 52
        ? trimmed.substring(48, 52).trim().replaceFirst(RegExp(r'^0+'), '')
        : '14B';
    final checkinSequence = trimmed.length >= 57
        ? trimmed.substring(52, 57).trim().replaceFirst(RegExp(r'^0+'), '')
        : '001';

    return BoardingPass(
      rawBarcode: trimmed,
      formatCode: formatCode,
      numberOfLegs: numberOfLegs,
      passengerName: passengerName,
      pnr: pnr,
      originAirport: originAirport,
      destinationAirport: destinationAirport,
      operatingCarrier: operatingCarrier,
      flightNumber: flightNumber,
      julianDate: julianDate,
      compartmentCode: compartmentCode,
      seatNumber: seatNumber,
      checkinSequence: checkinSequence,
      flightDateFormatted: _julianDateToString(julianDate),
    );
  }

  static String _formatPassengerName(String raw) {
    if (!raw.contains('/')) return raw;
    final parts = raw.split('/');
    final surname = parts[0].trim();
    var firstname = parts.length > 1 ? parts[1].trim() : '';

    firstname = firstname.replaceAll(RegExp(r'\s+(MR|MRS|MS|DR)$', caseSensitive: false), '');

    String cap(String s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';
    return '${cap(firstname)} ${cap(surname)}'.trim();
  }

  static String _julianDateToString(int julianDay) {
    final now = DateTime.now();
    final date = DateTime(now.year, 1, 1).add(Duration(days: julianDay - 1));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
