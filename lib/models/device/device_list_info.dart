class DeviceListInfo {
  final DateTime updateTime;
  final List<A10> devices;

  factory DeviceListInfo.initial() {
    return DeviceListInfo(devices: [], updateTime: DateTime.now());
  }

  DeviceListInfo({required this.updateTime, required this.devices});

  @override
  String toString() =>
      'CenterListInfo(updateTime: $updateTime, devices: $devices)';

  DeviceListInfo copyWith({
    DateTime? updateTime,
    List<A10>? devices,
  }) {
    return DeviceListInfo(
      updateTime: updateTime ?? this.updateTime,
      devices: devices ?? this.devices,
    );
  }
}

class A10 {
  final int id;
  final int parentCenterSn;
  final int centerSn;
  final String centerNm;
  final String deNumber;
  final String deName;
  final String deLocation;
  final double temp;
  final double hum;
  final int battery;
  final DateTime timeStamp;
  final String? description;
  final double positionX;
  final double positionY;
  final double tempLow;
  final double tempHigh;
  final double humLow;
  final double humHigh;

  factory A10.fromJsonLocal(Map<String, dynamic> json) {
    print(json.toString());
    return A10(
      id: json['id'],
      parentCenterSn:  json['parentCenterSn'],
      centerSn: json['centerSn'],
      centerNm: json['centerNm'],
      deNumber: json['deNumber'],
      deName: json['deName'],
      deLocation: json['deLocation'],
      temp: json['temp'],
      hum: json['hum'],
      battery: json['battery'],
      timeStamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      positionX: json['positionX'],
      positionY: json['positionY'],
      tempLow: json['tempLow'],
      tempHigh: json['tempHigh'],
      humLow: json['humLow'],
      humHigh: json['humHigh'],
    );
  }

  // factory A10.fromJsonUTC(Map<String, dynamic> json) {
  //   return A10(
  //     deNumber: json['deNumber'],
  //     centerSn: json['centerSn'],
  //     deName: json['deName'],
  //     temp: json['temp'],
  //     hum: json['hum'],
  //     battery: json['battery'],
  //     deLocation: json['deLocation'],
  //     tempLow: json['tempLow'],
  //     tempHigh: json['tempHigh'],
  //     humLow: json['humLow'],
  //     humHigh: json['humHigh'],
  //     timeStamp: DateTime.parse(json['start_time'] + 'Z').toLocal(),
  //     positionX: double.parse(json['positionX']),
  //     positionY: double.parse(json['positionY']),
  //   );
  // }

  A10(
      {required this.id,
      required this.parentCenterSn,
      required this.centerSn,
      required this.centerNm,
      required this.deNumber,
      required this.deName,
      required this.deLocation,
      required this.temp,
      required this.hum,
      required this.battery,
      required this.timeStamp,
      required this.description,
      required this.positionX,
      required this.positionY,
      required this.tempLow,
      required this.tempHigh,
      required this.humLow,
      required this.humHigh});

  A10 copyWith({
    int? id,
    int? parentCenterSn,
    int? centerSn,
    String? centerNn,
    String? deNumber,
    String? deName,
    String? deLocation,
    double? temp,
    double? hum,
    int? battery,
    DateTime? timeStamp,
    String? description,
    double? positionX,
    double? positionY,
    double? tempLow,
    double? tempHigh,
    double? humLow,
    double? humHigh,
  }) {
    return A10(
      id: id ?? this.id,
      parentCenterSn: parentCenterSn ?? this.parentCenterSn,
      centerSn: centerSn ?? this.centerSn,
      centerNm: centerNn ?? this.centerNm,
      deNumber: deNumber ?? this.deNumber,
      deName: deName ?? this.deName,
      deLocation: deLocation ?? this.deLocation,
      temp: temp ?? this.temp,
      hum: hum ?? this.hum,
      battery: battery ?? this.battery,
      timeStamp: timeStamp ?? this.timeStamp,
      description: description ?? this.description,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      tempLow: tempLow ?? this.tempLow,
      tempHigh: tempHigh ?? this.tempHigh,
      humLow: humLow ?? this.humLow,
      humHigh: humHigh ?? this.humHigh,
    );
  }

  @override
  String toString() {
    return 'A10(id: $id, parentCenterSn: $parentCenterSn, centerSn: $centerSn, centerNn: $centerNm, deNumber: $deNumber, deName: $deName, deLocation: $deLocation, temp: $temp, hum: $hum, battery: $battery, timeStamp: $timeStamp, description: $description, positionX: $positionX, positionY: $positionY, tempLow: $tempLow, tempHigh: $tempHigh, humLow: $humLow, humHigh: $humHigh)';
  }
}
