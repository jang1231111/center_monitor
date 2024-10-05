class CenterListInfo {
  final List<CenterInfo> centers;

  CenterListInfo({required this.centers});

  factory CenterListInfo.initial() {
    return CenterListInfo(centers: []);
  }

  CenterListInfo copyWith({
    List<CenterInfo>? centers,
  }) {
    return CenterListInfo(
      centers: centers ?? this.centers,
    );
  }

  @override
  String toString() => 'CenterListInfo(centers: $centers)';
}

class CenterInfo {
  final int id;
  final int centerSn;
  final String centerNm;
  final int total;
  final int inactive;
  final int tempWarn;
  final int humWarn;

  CenterInfo(
      {required this.id,
      required this.centerSn,
      required this.centerNm,
      required this.total,
      required this.inactive,
      required this.tempWarn,
      required this.humWarn});

  factory CenterInfo.initial() {
    return CenterInfo(
      id: 0,
      centerSn: 0,
      centerNm: '',
      total: 0,
      inactive: 0,
      tempWarn: 0,
      humWarn: 0,
    );
  }
  factory CenterInfo.fromJson(Map<String, dynamic> json) {
    return CenterInfo(
      id: json['id'],
      centerSn: json['centerSn'],
      centerNm: json['centerNm'],
      total: json['total'],
      inactive: json['inactive'],
      tempWarn: json['tempWarn'],
      humWarn: json['humWarn'],
    );
  }

  @override
  String toString() {
    return 'Center(id: $id, centerSn: $centerSn, centerNm: $centerNm, total: $total, inactive: $inactive, tempWarn: $tempWarn, humWarn: $humWarn)';
  }

  CenterInfo copyWith({
    int? id,
    int? centerSn,
    String? centerNm,
    int? total,
    int? inactive,
    int? tempWarn,
    int? humWarn,
  }) {
    return CenterInfo(
      id: id ?? this.id,
      centerSn: centerSn ?? this.centerSn,
      centerNm: centerNm ?? this.centerNm,
      total: total ?? this.total,
      inactive: inactive ?? this.inactive,
      tempWarn: tempWarn ?? this.tempWarn,
      humWarn: humWarn ?? this.humWarn,
    );
  }
}
