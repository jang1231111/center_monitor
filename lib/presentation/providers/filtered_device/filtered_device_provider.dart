import 'package:center_monitor/domain/entities/device/device_list_info.dart';
import 'package:center_monitor/domain/entities/filter/device_filter.dart';
import 'package:center_monitor/presentation/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/presentation/providers/center_search/center_search_provider.dart';
import 'package:center_monitor/presentation/providers/filtered_device/filtered_device_state.dart';

class FilteredDeviceProvider {
  final DeviceListProvider centerListProvider;
  final DeviceFilterProvider centerFilterProvider;
  final CenterSearchProvider centerSearchProvider;

  FilteredDeviceProvider(
      {required this.centerListProvider,
      required this.centerFilterProvider,
      required this.centerSearchProvider});

  FilteredDeviceState get state {
    List<A10> _filteredCenterList;
    List<A10> _centerList = centerListProvider.state.deviceListInfo.devices;

    switch (centerFilterProvider.state.filter) {
      case Filter.all:
        _filteredCenterList = _centerList;
        break;
      case Filter.a:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName!.contains('가');
        }).toList();
        break;
      case Filter.b:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName!.contains('나');
        }).toList();
        break;
      case Filter.c:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName!.contains('다');
        }).toList();
        break;
      case Filter.d:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName!.contains('라');
        }).toList();
        break;
      case Filter.e:
        _filteredCenterList = _centerList.where((A10 device) {
          return device.deName!.contains('마');
        }).toList();
        break;
    }

    if (centerSearchProvider.state.searchTerm.isNotEmpty) {
      _filteredCenterList = _filteredCenterList
          .where((A10 device) => device.centerNm
              .toLowerCase()
              .contains(centerSearchProvider.state.searchTerm))
          .toList();
    }

    // print('_filteredDevices $_filteredCenterList');

    return FilteredDeviceState(filtereCenterList: _filteredCenterList);
  }
}
