enum Filter {
  all,
  a,
  b,
  c,
  d,
  e,
}

class A10 {
  final String deNumber;
  final String centerSn;
  final String deName;
  final String temp;
  final String hum;
  final String battery;
  final String deLocation;
  final String tempLow;
  final String tempHigh;
  final String humLow;
  final String humHigh;
  final DateTime datetime;
  final DateTime startTime;
  final DateTime endTime;
  final double positionX;
  final double positionY;

  factory A10.fromJsonLocal(Map<String, dynamic> json) {
    return A10(
      deNumber: json['de_number'],
      centerSn: json['center_sn'],
      deName: json['de_name'],
      temp: json['temp'],
      hum: json['hum'],
      battery: json['battery'],
      deLocation: json['de_location'],
      tempLow: json['temp_low'],
      tempHigh: json['temp_high'],
      humLow: json['hum_low'],
      humHigh: json['hum_high'],
      datetime: DateTime.parse(json['datetime']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      positionX: double.parse(json['position_x']),
      positionY: double.parse(json['position_y']),
    );
  }

  factory A10.fromJsonUTC(Map<String, dynamic> json) {
    return A10(
      deNumber: json['de_number'],
      centerSn: json['center_sn'],
      deName: json['de_name'],
      temp: json['temp'],
      hum: json['hum'],
      battery: json['battery'],
      deLocation: json['de_location'],
      tempLow: json['temp_low'],
      tempHigh: json['temp_high'],
      humLow: json['hum_low'],
      humHigh: json['hum_high'],
      datetime: DateTime.parse(json['datetime'] + 'Z').toLocal(),
      startTime: DateTime.parse(json['start_time'] + 'Z').toLocal(),
      endTime: DateTime.parse(json['end_time'] + 'Z').toLocal(),
      positionX: double.parse(json['position_x']),
      positionY: double.parse(json['position_y']),
    );
  }

  A10(
      {required this.deNumber,
      required this.centerSn,
      required this.deName,
      required this.temp,
      required this.hum,
      required this.battery,
      required this.deLocation,
      required this.tempLow,
      required this.tempHigh,
      required this.humLow,
      required this.humHigh,
      required this.datetime,
      required this.startTime,
      required this.endTime,
      required this.positionX,
      required this.positionY});

  A10 copyWith({
    String? deNumber,
    String? centerSn,
    String? deName,
    String? temp,
    String? hum,
    String? battery,
    String? deLocation,
    String? tempLow,
    String? tempHigh,
    String? humLow,
    String? humHigh,
    DateTime? datetime,
    DateTime? startTime,
    DateTime? endTime,
    double? positionX,
    double? positionY,
  }) {
    return A10(
      deNumber: deNumber ?? this.deNumber,
      centerSn: centerSn ?? this.centerSn,
      deName: deName ?? this.deName,
      temp: temp ?? this.temp,
      hum: hum ?? this.hum,
      battery: battery ?? this.battery,
      deLocation: deLocation ?? this.deLocation,
      tempLow: tempLow ?? this.tempLow,
      tempHigh: tempHigh ?? this.tempHigh,
      humLow: humLow ?? this.humLow,
      humHigh: humHigh ?? this.humHigh,
      datetime: datetime ?? this.datetime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
    );
  }

  @override
  String toString() {
    return 'A10(deNumber: $deNumber, centerSn: $centerSn, deName: $deName, temp: $temp, hum: $hum, battery: $battery, deLocation: $deLocation, tempLow: $tempLow, tempHigh: $tempHigh, humLow: $humLow, humHigh: $humHigh, datetime: $datetime, startTime: $startTime, endTime: $endTime, positionX: $positionX, positionY: $positionY)';
  }
}
