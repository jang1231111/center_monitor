// ignore_for_file: public_member_api_docs, sort_constructors_first
class CenterSearchState {
  final String searchTerm;
  final bool isSearching;

  CenterSearchState({
    required this.searchTerm,
    required this.isSearching,
  });

  factory CenterSearchState.initial() {
    return CenterSearchState(searchTerm: '', isSearching: false);
  }

  @override
  String toString() =>
      'CenterSearchState(searchTerm: $searchTerm, isSearching: $isSearching)';

  CenterSearchState copyWith({
    String? searchTerm,
    bool? isSearching,
  }) {
    return CenterSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
