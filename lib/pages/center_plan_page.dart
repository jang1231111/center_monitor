import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class CenterPlanPage extends StatefulWidget {
  static const String routeName = '/picture';
  CenterPlanPage({super.key});

  @override
  State<CenterPlanPage> createState() => _CenterPlanPageState();
}

class _CenterPlanPageState extends State<CenterPlanPage> {
  @override
  Widget build(BuildContext context) {
    final loginNumber = context.read<LoginNumberProvider>().state.phoneNumber;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            PhotoView(
              imageProvider: loginNumber == '010-9999-9999'
                  ? Image.network(
                          'http://geo.logithermo.com/upload/center/geo/위험물%20인성창고.jpg')
                      .image
                  : Image.network(
                          'http://175.126.232.236:9092/upload/center/175/MNB.jpg')
                      .image,
              minScale: PhotoViewComputedScale.contained,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 45, right: 20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "센터 도면",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
