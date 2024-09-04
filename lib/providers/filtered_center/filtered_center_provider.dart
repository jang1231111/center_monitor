import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/providers/center_filter/center_filter_provider.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/filtered_center/filtered_center_state.dart';

class FilteredCenterProvider {
  final CenterListProvider centerListProvider;
  final CenterFilterProvider centerFilterProvider;

  FilteredCenterProvider(
      {required this.centerFilterProvider, required this.centerListProvider});

  FilteredCenterState get state {
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

    return FilteredCenterState(filtereCenterList: _filteredCenterList);
  }
}
