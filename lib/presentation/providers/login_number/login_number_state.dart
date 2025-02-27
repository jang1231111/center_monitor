class LoginNumberState {
  String phoneNumber;
  LoginNumberState({
    required this.phoneNumber,
  });

  factory LoginNumberState.intitial() {
    return LoginNumberState(phoneNumber: '010-8070-9033');
  }

  @override
  String toString() => 'LoginNumberState(phontNumber: $phoneNumber)';

  LoginNumberState copyWith({
    String? phontNumber,
  }) {
    return LoginNumberState(
      phoneNumber: phontNumber ?? this.phoneNumber,
    );
  }
}
