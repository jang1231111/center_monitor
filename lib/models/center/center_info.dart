class CenterInfo {
  String token;
  String center;
  CenterInfo({
    required this.token,
    required this.center,
  });

  factory CenterInfo.initial() {
    return CenterInfo(token: 'Initial', center: 'Initial');
  }

  CenterInfo copyWith({
    String? token,
    String? center,
  }) {
    return CenterInfo(
      token: token ?? this.token,
      center: center ?? this.center,
    );
  }

  @override
  String toString() => 'CenterInfo(token: $token, center: $center)';
}
