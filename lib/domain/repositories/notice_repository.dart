import 'package:center_monitor/domain/entities/notice/notice.dart';

abstract class NoticeRepository {
  Future<Notice> getNotice();
}
