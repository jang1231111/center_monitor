import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/providers/filtered_device/filtered_device_state.dart';

class FilteredDeviceProvider {
  final DeviceListProvider centerListProvider;
  final DeviceFilterProvider centerFilterProvider;

  FilteredDeviceProvider(
      {required this.centerFilterProvider, required this.centerListProvider});

  FilteredDeviceState get state {
    List<A10> _filteredCenterList;
    List<A10> _centerList = centerListProvider.state.centerListInfo.devices;

    switch (centerFilterProvider.state.filter) {
      case Filter.all:
        _filteredCenterList = _centerList;
        break;
      case Filter.a:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName.contains('가');
        }).toList();
        break;
      case Filter.b:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName.contains('나');
        }).toList();
        break;
      case Filter.c:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName.contains('다');
        }).toList();
        break;
      case Filter.d:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName.contains('라');
        }).toList();
        break;
      case Filter.e:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName.contains('마');
        }).toList();
        break;
    }

    // print('_filteredDevices $_filteredDevices');

    return FilteredDeviceState(filtereCenterList: _filteredCenterList);
  }
}
