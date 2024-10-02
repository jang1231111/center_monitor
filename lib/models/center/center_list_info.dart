class CenterListInfo {
  final List<Center> centers;

  CenterListInfo({required this.centers});

  CenterListInfo copyWith({
    List<Center>? centers,
  }) {
    return CenterListInfo(
      centers: centers ?? this.centers,
    );
  }

  @override
  String toString() => 'CenterListInfo(centers: $centers)';
}

class Center {
  final String id;
  final String centerSn;
  final String centerNm;
  final String total;
  final String inactive;
  final String tempWarn;
  final String humWarn;

  Center(
      {required this.id,
      required this.centerSn,
      required this.centerNm,
      required this.total,
      required this.inactive,
      required this.tempWarn,
      required this.humWarn});

  factory Center.fromJsonLocal(Map<String, dynamic> json) {
    return Center(
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

  Center copyWith({
    String? id,
    String? centerSn,
    String? centerNm,
    String? total,
    String? inactive,
    String? tempWarn,
    String? humWarn,
  }) {
    return Center(
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
