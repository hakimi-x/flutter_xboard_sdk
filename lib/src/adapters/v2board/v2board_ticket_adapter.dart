import '../../api/interfaces/ticket_api.dart';
import '../../api/models/ticket_model.dart';
import '../../panels/v2board/apis/v2board_ticket_api.dart';
import '../../panels/xboard/models/xboard_ticket_models.dart';

class V2BoardTicketAdapter implements TicketApi {
  final V2BoardTicketApi _api;

  V2BoardTicketAdapter(this._api);

  @override
  Future<List<TicketModel>> getTickets({int page = 1, int pageSize = 10}) async {
    final response = await _api.fetchTickets();
    if (response.data == null) return [];
    return response.data!.map(_mapTicket).toList();
  }

  @override
  Future<TicketDetailModel> getTicket(int id) async {
    final response = await _api.getTicketDetail(id);
    if (response.data == null) throw Exception('Ticket detail is null');
    return _mapTicketDetail(response.data!);
  }

  @override
  Future<bool> createTicket(String subject, String message, int level) async {
    await _api.createTicket(subject: subject, level: level, message: message);
    return true;
  }

  @override
  Future<bool> replyTicket(int id, String message) async {
    await _api.replyTicket(ticketId: id, message: message);
    return true;
  }

  @override
  Future<bool> closeTicket(int id) async {
    await _api.closeTicket(id);
    return true;
  }

  TicketModel _mapTicket(Ticket ticket) {
    return TicketModel(
      id: ticket.id,
      level: ticket.level,
      replyStatus: ticket.replyStatus,
      status: ticket.status,
      subject: ticket.subject,
      message: ticket.message,
      createdAt: ticket.createdAt,
      updatedAt: ticket.updatedAt,
      userId: ticket.userId,
    );
  }

  TicketDetailModel _mapTicketDetail(TicketDetail detail) {
    return TicketDetailModel(
      id: detail.id,
      level: detail.level,
      replyStatus: detail.replyStatus,
      status: detail.status,
      subject: detail.subject,
      messages: detail.messages.map(_mapTicketMessage).toList(),
      createdAt: detail.createdAt,
      updatedAt: detail.updatedAt,
      userId: detail.userId,
    );
  }

  TicketMessageModel _mapTicketMessage(TicketMessage message) {
    return TicketMessageModel(
      id: message.id,
      ticketId: message.ticketId,
      isMe: message.isMe,
      message: message.message,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
    );
  }
}
