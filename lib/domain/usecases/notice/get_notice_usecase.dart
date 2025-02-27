import 'package:center_monitor/domain/entities/notice/notice.dart';
import 'package:center_monitor/domain/repositories/notice_repository.dart';

class GetNoticeUsecase {
  final NoticeRepository _repository;

  GetNoticeUsecase(this._repository);

  Future<Notice> execute() async {
    return await _repository.getNotice();
  }
}
