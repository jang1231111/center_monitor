import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showVersionUpdateDialog(BuildContext context, String downloadLink) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('최신 버전이 아닙니다.'),
          content: Text('업데이트 하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Update'),
              onPressed: () async {
                print('downloadLink $downloadLink');
                if (await canLaunchUrl(Uri.parse(downloadLink))) {
                  await launchUrl(Uri.parse(downloadLink),
                      mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $downloadLink';
                }
              },
            )
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('최신 버전이 아닙니다.'),
          content: Text('업데이트 하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                await launchUrl(Uri.parse(downloadLink));
              },
            )
          ],
        );
      },
    );
  }
}
