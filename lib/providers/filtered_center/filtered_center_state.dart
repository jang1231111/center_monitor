import 'package:center_monitor/models/a10_model.dart';

class FilteredCenterState {
  final List<A10> filtereCenterList;

  FilteredCenterState({required this.filtereCenterList});

  factory FilteredCenterState.initial() {
    return FilteredCenterState(filtereCenterList: []);
  }

  @override
  String toString() =>
      'FilteredDevicesState(filteredDevices: $filtereCenterList)';

  FilteredCenterState copyWith({
    List<A10>? filteredDevices,
  }) {
    return FilteredCenterState(
      filtereCenterList: filteredDevices ?? this.filtereCenterList,
    );
  }
}
