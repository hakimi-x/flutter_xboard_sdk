// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

int? _toUnixTimestamp(int? date) => date;
int _fromUnixTimestamp(int? timestamp) => timestamp ?? 0;

bool _showFromJson(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  return false;
}

dynamic _showToJson(bool value) => value ? 1 : 0;

@freezed
class NoticeModel with _$NoticeModel {
  const factory NoticeModel({
    required int id,
    required String title,
    required String content,
    @JsonKey(fromJson: _showFromJson, toJson: _showToJson)
    required bool show,
    @JsonKey(name: 'img_url') String? imgUrl,
    List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    required int createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    required int updatedAt,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) => _$NoticeModelFromJson(json);
}
