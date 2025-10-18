/// XBoard SDK基础异常类
abstract class XBoardException implements Exception {
  final String message;
  final int? code;

  XBoardException(this.message, [this.code]);

  @override
  String toString() {
    return code != null 
        ? 'XBoardException($code): $message'
        : 'XBoardException: $message';
  }
}

/// 网络异常
class NetworkException extends XBoardException {
  NetworkException(super.message, [super.code]);
}

/// 认证异常
class AuthException extends XBoardException {
  AuthException(super.message, [super.code]);
}

/// API异常
class ApiException extends XBoardException {
  ApiException(super.message, [super.code]);
}

/// 配置异常
class ConfigException extends XBoardException {
  ConfigException(super.message, [super.code]);
}

/// 参数异常
class ParameterException extends XBoardException {
  ParameterException(super.message, [super.code]);
}

/// 证书验证异常
class CertificateException extends XBoardException {
  CertificateException(super.message, [super.code]);
} 