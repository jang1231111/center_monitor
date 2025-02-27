import 'dart:io';
import 'package:center_monitor/domain/entities/notice/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showNoticeDialog(BuildContext context, Notice notice) async {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('${notice.title}'),
          content: Text('${notice.content}'),
          actions: [
            CupertinoDialogAction(
              child: Text('확인'),
              onPressed: () async {
                Navigator.pop(context);
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
          title: Text('${notice.title}'),
          content: Text('${notice.content}'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
