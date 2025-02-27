// ignore_for_file: public_member_api_docs, sort_constructors_first
class VersionState {
  bool isUpdateRequired;
  String? downloadLink;

  VersionState({
    required this.isUpdateRequired,
    required this.downloadLink,
  });

  factory VersionState.initial() {
    return VersionState(
      downloadLink: null,
      isUpdateRequired: false,
    );
  }

  VersionState copyWith({
    bool? isUpdateRequired,
    String? downloadLink,
  }) {
    return VersionState(
      isUpdateRequired: isUpdateRequired ?? this.isUpdateRequired,
      downloadLink: downloadLink ?? this.downloadLink,
    );
  }
}
