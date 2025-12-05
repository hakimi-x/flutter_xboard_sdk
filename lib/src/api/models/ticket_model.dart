// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

DateTime _fromUnixTimestamp(int timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
int _toUnixTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

@freezed
class TicketModel with _$TicketModel {
  const factory TicketModel({
    required int id,
    required int level,
    @JsonKey(name: 'reply_status') required int replyStatus,
    required int status,
    required String subject,
    String? message,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
    @JsonKey(name: 'user_id') required int userId,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);
}

@freezed
class TicketMessageModel with _$TicketMessageModel {
  const factory TicketMessageModel({
    required int id,
    @JsonKey(name: 'ticket_id') required int ticketId,
    @JsonKey(name: 'is_me') required bool isMe,
    required String message,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
  }) = _TicketMessageModel;

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) => _$TicketMessageModelFromJson(json);
}

@freezed
class TicketDetailModel with _$TicketDetailModel {
  const factory TicketDetailModel({
    required int id,
    required int level,
    @JsonKey(name: 'reply_status') required int replyStatus,
    required int status,
    required String subject,
    @Default([]) List<TicketMessageModel> messages,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
    @JsonKey(name: 'user_id') required int userId,
  }) = _TicketDetailModel;

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) => _$TicketDetailModelFromJson(json);
}
