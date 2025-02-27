import 'package:center_monitor/domain/entities/notice/notice.dart';

class NoticeModel extends Notice {
  NoticeModel(
      {required super.useYn, required super.title, required super.content});

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      useYn: map['useYn'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "useYn": useYn,
      "title": title,
      "content": content,
    };
  }
}
