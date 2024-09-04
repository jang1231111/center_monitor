import 'package:center_monitor/models/a10_model.dart';
import 'package:equatable/equatable.dart';

class CenterFilterState extends Equatable {
  final Filter filter;

  CenterFilterState({
    required this.filter,
  });

  factory CenterFilterState.initial() {
    return CenterFilterState(filter: Filter.all);
  }

  @override
  String toString() => 'TodoFilterState(filter: $filter)';

  @override
  List<Object?> get props => [filter];

  CenterFilterState copyWith({
    Filter? filter,
  }) {
    return CenterFilterState(
      filter: filter ?? this.filter,
    );
  }
}
