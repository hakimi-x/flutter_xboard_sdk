import '../models/ticket_model.dart';

abstract class TicketApi {
  Future<List<TicketModel>> getTickets({int page = 1, int pageSize = 10});
  Future<TicketDetailModel> getTicket(int id);
  Future<bool> createTicket(String subject, String message, int level);
  Future<bool> replyTicket(int id, String message);
  Future<bool> closeTicket(int id);
}
