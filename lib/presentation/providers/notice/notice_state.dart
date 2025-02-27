// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:center_monitor/domain/entities/notice/notice.dart';

class NoticeState {
  Notice notice;

  NoticeState({
    required this.notice,
  });

  factory NoticeState.initial() {
    return NoticeState(notice: Notice(useYn: 'N', title: '', content: ''));
  }

  @override
  String toString() => 'NoticeState(notice: $notice)';

  NoticeState copyWith({
    Notice? notice,
  }) {
    return NoticeState(
      notice: notice ?? this.notice,
    );
  }
}
