import 'package:center_monitor/data/datasources/remote/remote_data_source.dart';
import 'package:center_monitor/domain/entities/notice/notice.dart';
import 'package:center_monitor/domain/repositories/notice_repository.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  final RemoteDataSource _remoteDataSource;

  NoticeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Notice> getNotice() async {
    final notice = await _remoteDataSource.fetchNotice();
    return Notice(
        useYn: notice.useYn, title: notice.title, content: notice.content);
  }
}
