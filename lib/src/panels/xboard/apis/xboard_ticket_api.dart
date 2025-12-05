import '../../../core/http/http_service.dart';
import '../models/xboard_ticket_models.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 工单 API 实现
class XBoardTicketApi {
  final HttpService _httpService;

  XBoardTicketApi(this._httpService);

  Future<ApiResponse<List<Ticket>>> fetchTickets() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/ticket/fetch');
      return ApiResponse.fromJson(
        result,
        (json) => (json as List<dynamic>)
            .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取工单列表时发生错误: $e');
    }
  }

  Future<ApiResponse<Ticket?>> createTicket({
    required String subject,
    required int level,
    required String message,
  }) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/ticket/withdraw', {
        'subject': subject,
        'message': message,
        'level': level,
      });
      // API可能返回bool表示成功，而不是返回Ticket对象
      return ApiResponse.fromJson(result, (json) {
        if (json is Map<String, dynamic>) {
          return Ticket.fromJson(json);
        }
        // 如果是bool或其他类型，返回null，表示创建成功但没有返回详情
        return null;
      });
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('创建工单时发生错误: $e');
    }
  }

  Future<ApiResponse<TicketDetail>> getTicketDetail(int ticketId) async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/ticket/fetch?id=$ticketId');
      return ApiResponse.fromJson(result, (json) {
        // 确保messages字段存在且为列表
        final data = json as Map<String, dynamic>;
        if (data['messages'] == null) {
          data['messages'] = [];
        }
        return TicketDetail.fromJson(data);
      });
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取工单详情时发生错误: $e');
    }
  }

  Future<ApiResponse<void>> replyTicket({
    required int ticketId,
    required String message,
  }) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/ticket/reply', {
        'id': ticketId,
        'message': message,
      });
      return ApiResponse.fromJson(result, (json) {});
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('回复工单失败: $e');
    }
  }

  Future<ApiResponse<void>> closeTicket(String ticketId) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/ticket/close', {
        'id': ticketId,
      });
      return ApiResponse.fromJson(result, (json) {});
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('关闭工单时发生错误: $e');
    }
  }
}
