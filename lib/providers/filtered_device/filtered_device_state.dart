import 'package:center_monitor/models/a10_model.dart';

class FilteredDeviceState {
  final List<A10> filtereCenterList;

  FilteredDeviceState({required this.filtereCenterList});

  factory FilteredDeviceState.initial() {
    return FilteredDeviceState(filtereCenterList: []);
  }

  @override
  String toString() =>
      'FilteredDevicesState(filteredDevices: $filtereCenterList)';

  FilteredDeviceState copyWith({
    List<A10>? filteredDevices,
  }) {
    return FilteredDeviceState(
      filtereCenterList: filteredDevices ?? this.filtereCenterList,
    );
  }
}
