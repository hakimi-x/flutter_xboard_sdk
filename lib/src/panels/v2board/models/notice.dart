// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

/// 公告数据模型
@freezed
class Notice with _$Notice {
  const Notice._();
  
  const factory Notice({
    int? id,
    String? title,
    String? content,
    int? show,
    @JsonKey(name: 'img_url') String? imgUrl,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _Notice;
  
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  
  /// 是否显示
  bool get isVisible => show == 1;
}
