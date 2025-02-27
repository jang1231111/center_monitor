import 'package:center_monitor/domain/entities/filter/device_filter.dart';
import 'package:equatable/equatable.dart';

class DeviceFilterState extends Equatable {
  final Filter filter;

  DeviceFilterState({
    required this.filter,
  });

  factory DeviceFilterState.initial() {
    return DeviceFilterState(filter: Filter.all);
  }

  @override
  String toString() => 'TodoFilterState(filter: $filter)';

  @override
  List<Object?> get props => [filter];

  DeviceFilterState copyWith({
    Filter? filter,
  }) {
    return DeviceFilterState(
      filter: filter ?? this.filter,
    );
  }
}
