import 'package:flutter/material.dart';

class CenterChoiceDialog extends StatelessWidget {
  const CenterChoiceDialog({super.key, required this.centers});

  final List<String> centers;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) {
    List<String> centersTest = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'b',
      'c',
      'd',
      'e'
    ];
    return Container(
      height: 350,
      decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text('센터 선택'),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: centersTest.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return centerButton(centersTest[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

centerButton(String centerName) {
  return TextButton(
    onPressed: () async {
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
      '${centerName}',
      style: TextStyle(
        color: Color.fromARGB(255, 38, 94, 176),
      ),
    ),
  );
}
