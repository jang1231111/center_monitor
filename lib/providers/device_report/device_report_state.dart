class DeviceReportState {
  final double tempLow;
  final double tempHigh;
  final double humLow;
  final double humHigh;

  DeviceReportState(
      {required this.tempLow,
      required this.tempHigh,
      required this.humLow,
      required this.humHigh});

  @override
  String toString() {
    return 'CenterReportState(tempLow: $tempLow, tempHigh: $tempHigh, humLow: $humLow, humHigh: $humHigh)';
  }

  DeviceReportState copyWith({
    double? tempLow,
    double? tempHigh,
    double? humLow,
    double? humHigh,
  }) {
    return DeviceReportState(
      tempLow: tempLow ?? this.tempLow,
      tempHigh: tempHigh ?? this.tempHigh,
      humLow: humLow ?? this.humLow,
      humHigh: humHigh ?? this.humHigh,
    );
  }
}
