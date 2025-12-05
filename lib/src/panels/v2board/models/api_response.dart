/// API 统一响应格式
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  
  ApiResponse({
    this.data,
    this.message,
    required this.success,
  });
  
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      data: json['data'] as T?,
      message: json['message'] as String?,
      success: json['data'] != null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
    };
  }
}

