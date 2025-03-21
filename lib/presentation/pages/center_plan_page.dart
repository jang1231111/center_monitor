import 'dart:typed_data';
import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CenterPlanPage extends StatefulWidget {
  static const String routeName = '/picture';
  CenterPlanPage({super.key});

  @override
  State<CenterPlanPage> createState() => _CenterPlanPageState();
}

class _CenterPlanPageState extends State<CenterPlanPage> {
  @override
  Widget build(BuildContext context) {
    final bitmap = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Bitmap;
    Uint8List headedIntList = bitmap.buildHeaded();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            PhotoView(
              imageProvider: MemoryImage(headedIntList),
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
