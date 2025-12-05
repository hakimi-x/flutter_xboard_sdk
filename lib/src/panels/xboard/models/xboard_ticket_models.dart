// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_ticket_models.freezed.dart';
part 'xboard_ticket_models.g.dart';

DateTime _fromUnixTimestamp(int timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
int _toUnixTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required int id,
    required int level, // 优先级: 0=低, 1=中, 2=高
    @JsonKey(name: 'reply_status') required int replyStatus, // 回复状态: 0=已回复, 1=等待回复
    required int status, // 工单状态: 0=处理中, 1=已关闭
    required String subject,
    String? message,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
    @JsonKey(name: 'user_id') required int userId,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
}

@freezed
class TicketMessage with _$TicketMessage {
  const factory TicketMessage({
    required int id,
    @JsonKey(name: 'ticket_id') required int ticketId,
    @JsonKey(name: 'is_me') required bool isMe,
    required String message,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
  }) = _TicketMessage;

  factory TicketMessage.fromJson(Map<String, dynamic> json) => _$TicketMessageFromJson(json);
}

@freezed
class TicketDetail with _$TicketDetail {
  const factory TicketDetail({
    required int id,
    required int level,
    @JsonKey(name: 'reply_status') required int replyStatus,
    required int status,
    required String subject,
    @Default([]) List<TicketMessage> messages,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
    @JsonKey(name: 'user_id') required int userId,
  }) = _TicketDetail;

  factory TicketDetail.fromJson(Map<String, dynamic> json) => _$TicketDetailFromJson(json);
}
