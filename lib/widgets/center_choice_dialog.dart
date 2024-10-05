import 'package:center_monitor/constants/style.dart';
import 'package:center_monitor/models/center/center_list_info.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showCenterChoiceDialog(BuildContext context, List<CenterInfo> centers) {
  // if (Platform.isIOS) {
  //   showCupertinoDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         title: Text('Error'),
  //         content: Text(errorMessage),
  //         actions: [
  //           CupertinoDialogAction(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // } else {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: showCenters(context, centers),
      );
    },
  );
}
// }

showCenters(BuildContext context, List<CenterInfo> centers) {
  return Container(
    height: 350,
    decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12))),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Text(
              '센터를 선택해주세요',
              style: TextStyle(
                color: Color.fromRGBO(0, 54, 92, 1),
                fontSize: MediaQuery.of(context).size.width / 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'pretend',
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
            child: Divider(
              height: 5,
            ),
          ),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: centers.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return centerButton(context, centers[index]);
            },
          ),
        ],
      ),
    ),
  );
}

centerButton(BuildContext context, CenterInfo center) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 38, 94, 176),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [mainbox()],
      ),
      child: TextButton(
        onPressed: () async {
          final selectedInfo =
              context.read<CenterListProvider>().state.selectedCenterInfo;

          await context.read<DeviceListProvider>().getDeviceList( 
              centerSn: center.centerSn, 
              token: selectedInfo.token,
              company: selectedInfo.company);

          await Navigator.pushNamed(
            context,
            MainPage.routeName,
          );
          // String _loginNumber =context.read<LoginNumberProvider>().state.phoneNumber;
          // try {
          //   await context
          //       .read<CenterDataProvider>()
          //       .getCenterData(device: device, loginNumber: _loginNumber);
          //   Navigator.pop(context);
          //   Navigator.pushNamed(context, DetailPage.routeName,
          //       arguments: device.copyWith());
          // } on CustomError catch (e) {
          //   errorDialog(context, e.toString());
          // }
        },
        child: Text(
          '${center.centerNm}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
