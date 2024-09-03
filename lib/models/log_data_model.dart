class LogData {
  final String temp;
  final String hum;
  final DateTime dateTime;

  LogData({required this.temp, required this.hum, required this.dateTime});

  factory LogData.fromJson(Map<String, dynamic> json) {
    return LogData(
      temp: json['temp'],
      hum: json['hum'],
      dateTime: DateTime.parse(json['datetime']),
    );
  }

  @override
  String toString() => 'LogData(temp: $temp, hum: $hum, dateTime: $dateTime)';
}
