import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_ticket_models.dart';

/// V2Board 工单 API 实现
class V2BoardTicketApi {
  final HttpService _httpService;

  V2BoardTicketApi(this._httpService);

  Future<ApiResponse<List<Ticket>>> fetchTickets() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/ticket/fetch');
      final List<dynamic> ticketsJson = result['data'] as List? ?? [];
      final tickets = ticketsJson.map((json) => Ticket.fromJson(json as Map<String, dynamic>)).toList();
      return ApiResponse(success: true, data: tickets);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取工单列表失败: $e');
    }
  }

  Future<ApiResponse<TicketDetail>> getTicketDetail(int ticketId) async {
    try {
      final result = await _httpService.getRequest(
        '/api/v1/user/ticket/fetch?id=$ticketId',
      );
      final ticket = TicketDetail.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: ticket);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取工单详情失败: $e');
    }
  }

  Future<ApiResponse<Ticket>> createTicket({
    required String subject,
    required int level,
    required String message,
  }) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/ticket/save',
        {
          'subject': subject,
          'level': level,
          'message': message,
        },
      );
      final ticket = Ticket.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: ticket);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 创建工单失败: $e');
    }
  }

  Future<ApiResponse<void>> replyTicket({
    required int ticketId,
    required String message,
  }) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/ticket/reply',
        {'id': ticketId, 'message': message},
      );
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 回复工单失败: $e');
    }
  }

  Future<ApiResponse<void>> closeTicket(int ticketId) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/ticket/close',
        {'id': ticketId},
      );
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 关闭工单失败: $e');
    }
  }
}
