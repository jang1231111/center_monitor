class CenterSearchState {
  final String searchTerm;

  CenterSearchState({required this.searchTerm});

  factory CenterSearchState.initial() {
    return CenterSearchState(searchTerm: '');
  }

  @override
  String toString() => 'DeviceSearchState(searchTerm: $searchTerm)';

  CenterSearchState copyWith({
    String? searchTerm,
  }) {
    return CenterSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
