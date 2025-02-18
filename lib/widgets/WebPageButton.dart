import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Color
// text
// Url

class WebPageButton extends StatelessWidget {
  final String text;
  final String url;
  final Color color;

  const WebPageButton(
      {super.key, required this.text, required this.url, required this.color});

  Future<void> _launchURL(String url) async {
    print(url);
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication); // 외부 브라우저에서 열기
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('$text $url');

    return TextButton(
      onPressed: () async {
        _launchURL(url);
      }, // 버튼 클릭 시 웹페이지 열기
      child: Text(
        '$text',
        style: TextStyle(fontSize: 15, color: color),
      ),
    );
  }
}
