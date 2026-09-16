class BoardingPass {
  final String rawBarcode;
  final String formatCode;
  final int numberOfLegs;
  final String passengerName;
  final String pnr;
  final String originAirport;
  final String destinationAirport;
  final String operatingCarrier;
  final String flightNumber;
  final int julianDate;
  final String compartmentCode;
  final String seatNumber;
  final String checkinSequence;
  final String flightDateFormatted;

  BoardingPass({
    required this.rawBarcode,
    required this.formatCode,
    required this.numberOfLegs,
    required this.passengerName,
    required this.pnr,
    required this.originAirport,
    required this.destinationAirport,
    required this.operatingCarrier,
    required this.flightNumber,
    required this.julianDate,
    required this.compartmentCode,
    required this.seatNumber,
    required this.checkinSequence,
    required this.flightDateFormatted,
  });

  factory BoardingPass.fromJson(Map<String, dynamic> json) {
    return BoardingPass(
      rawBarcode: json['rawBarcode'] ?? '',
      formatCode: json['formatCode'] ?? 'M',
      numberOfLegs: json['numberOfLegs'] ?? 1,
      passengerName: json['passengerName'] ?? 'Pasager',
      pnr: json['pnr'] ?? '',
      originAirport: json['originAirport'] ?? 'OTP',
      destinationAirport: json['destinationAirport'] ?? 'CDG',
      operatingCarrier: json['operatingCarrier'] ?? 'RO',
      flightNumber: json['flightNumber'] ?? 'RO391',
      julianDate: json['julianDate'] ?? 258,
      compartmentCode: json['compartmentCode'] ?? 'Y',
      seatNumber: json['seatNumber'] ?? '14B',
      checkinSequence: json['checkinSequence'] ?? '001',
      flightDateFormatted: json['flightDateFormatted'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rawBarcode': rawBarcode,
      'formatCode': formatCode,
      'numberOfLegs': numberOfLegs,
      'passengerName': passengerName,
      'pnr': pnr,
      'originAirport': originAirport,
      'destinationAirport': destinationAirport,
      'operatingCarrier': operatingCarrier,
      'flightNumber': flightNumber,
      'julianDate': julianDate,
      'compartmentCode': compartmentCode,
      'seatNumber': seatNumber,
      'checkinSequence': checkinSequence,
      'flightDateFormatted': flightDateFormatted,
    };
  }
}
