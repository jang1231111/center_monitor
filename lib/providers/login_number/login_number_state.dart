class LoginNumberState {
  String phontNumber;
  LoginNumberState({
    required this.phontNumber,
  });

  factory LoginNumberState.intitial() {
    return LoginNumberState(phontNumber: '010-8070-9033');
  }

  @override
  String toString() => 'LoginNumberState(phontNumber: $phontNumber)';

  LoginNumberState copyWith({
    String? phontNumber,
  }) {
    return LoginNumberState(
      phontNumber: phontNumber ?? this.phontNumber,
    );
  }
}
