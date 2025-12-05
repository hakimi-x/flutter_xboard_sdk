import '../../api/interfaces/notice_api.dart';
import '../../api/models/notice_model.dart';
import '../../panels/v2board/apis/v2board_notice_api.dart';
import '../../panels/xboard/models/xboard_notice_models.dart';

class V2BoardNoticeAdapter implements NoticeApi {
  final V2BoardNoticeApi _api;

  V2BoardNoticeAdapter(this._api);

  @override
  Future<List<NoticeModel>> getNotices({int page = 1, int pageSize = 10}) async {
    final response = await _api.fetchNotices();
    if (response.data == null) return [];
    return response.data!.map(_mapNotice).toList();
  }

  NoticeModel _mapNotice(Notice notice) {
    return NoticeModel(
      id: notice.id,
      title: notice.title,
      content: notice.content,
      show: notice.show,
      imgUrl: notice.imgUrl,
      tags: notice.tags,
      createdAt: notice.createdAt,
      updatedAt: notice.updatedAt,
    );
  }
}
