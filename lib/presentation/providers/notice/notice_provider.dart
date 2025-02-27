import 'package:center_monitor/domain/usecases/notice/get_notice_usecase.dart';
import 'package:center_monitor/presentation/providers/notice/notice_state.dart';
import 'package:flutter/widgets.dart';

class NoticeProvider extends ChangeNotifier {
  NoticeState _state = NoticeState.initial();
  NoticeState get state => _state;

  GetNoticeUsecase getNoticeUsecase;

  NoticeProvider({
    required this.getNoticeUsecase,
  });

  Future<void> getNotice() async {
    final notice = await getNoticeUsecase.execute();
    _state = _state.copyWith(notice: notice);
    notifyListeners();
  }
}
