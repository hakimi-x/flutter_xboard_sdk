import 'core/http/http_service.dart';
import 'core/auth/token_manager.dart';
import 'core/factory/panel_type.dart';
import 'core/factory/api_factory.dart';
import 'core/http/http_config.dart';
import 'core/exceptions/xboard_exceptions.dart';
import 'core/logging/sdk_logger.dart';

import 'api/interfaces/user_api.dart';
import 'api/interfaces/plan_api.dart';
import 'api/interfaces/order_api.dart';
import 'api/interfaces/subscription_api.dart';
import 'api/interfaces/invite_api.dart';
import 'api/interfaces/notice_api.dart';
import 'api/interfaces/ticket_api.dart';
import 'api/interfaces/config_api.dart';
import 'api/interfaces/payment_api.dart';
import 'api/interfaces/auth_api.dart';

/// XBoard SDK主类
/// 提供对XBoard API的统一访问接口
class XBoardSDK {
  static XBoardSDK? _instance;
  static XBoardSDK get instance => _instance ??= XBoardSDK._internal();

  XBoardSDK._internal();

  late HttpService _httpService;
  late TokenManager _tokenManager;
  late ApiFactory _apiFactory;
  PanelType? _panelType;

  // Unified APIs (Lazy Loaded)
  UserApi? _userApi;
  PlanApi? _planApi;
  OrderApi? _orderApi;
  SubscriptionApi? _subscriptionApi;
  InviteApi? _inviteApi;
  NoticeApi? _noticeApi;
  TicketApi? _ticketApi;
  ConfigApi? _configApi;
  PaymentApi? _paymentApi;
  AuthApi? _authApi;

  bool _isInitialized = false;

  /// 初始化SDK
  Future<void> initialize(
    String baseUrl, {
    required String panelType,
    String? proxyUrl,
    String? userAgent,
    HttpConfig? httpConfig,
    bool useMemoryStorage = false,
    bool enableLogging = false,
    bool usePrintLogger = false,
  }) async {
    if (_isInitialized) {
      SdkLogger.w('SDK is already initialized. Call dispose() first if you want to re-initialize.');
      return;
    }

    if (baseUrl.isEmpty) {
      throw ConfigException('Base URL cannot be empty');
    }

    if (panelType.isEmpty) {
      throw ConfigException('Panel type cannot be empty');
    }

    SdkLogger.enable(enabled: enableLogging, usePrint: usePrintLogger);

    // 解析面板类型
    _panelType = PanelType.fromString(panelType);

    // 移除URL末尾的斜杠
    final cleanUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    // 初始化TokenManager
    _tokenManager = useMemoryStorage ? TokenManager.memory() : TokenManager();

    // 初始化HTTP服务
    final finalHttpConfig = httpConfig ?? 
      (proxyUrl != null || userAgent != null
        ? HttpConfig.development(
            proxyUrl: proxyUrl,
            userAgent: userAgent,
          )
        : HttpConfig.defaultConfig());
    
    _httpService = await HttpService.create(
      cleanUrl, 
      tokenManager: _tokenManager, 
      httpConfig: finalHttpConfig,
    );

    // 创建 API 工厂
    _apiFactory = ApiFactory(_panelType!, _httpService);

    _isInitialized = true;
    SdkLogger.i('XBoardSDK initialized with panel type: $_panelType');
  }

  /// 保存Token
  Future<void> saveToken(String token) async {
    _checkInitialized();
    final fullToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
    await _tokenManager.saveToken(fullToken);
  }

  /// 获取当前Token
  Future<String?> getToken() async {
    _checkInitialized();
    return await _tokenManager.getToken();
  }

  /// 清除Token
  Future<void> clearToken() async {
    _checkInitialized();
    await _tokenManager.clearToken();
  }

  /// 检查是否有Token
  Future<bool> hasToken() async {
    _checkInitialized();
    return await _tokenManager.hasToken();
  }

  /// 检查SDK是否已初始化
  bool get isInitialized => _isInitialized;

  /// 获取认证状态流
  Stream<AuthState> get authStateStream {
    _checkInitialized();
    return _tokenManager.authStateStream;
  }

  /// 获取当前认证状态
  AuthState get authState {
    _checkInitialized();
    return _tokenManager.currentState;
  }

  /// 是否已认证
  bool get isAuthenticated {
    _checkInitialized();
    return _tokenManager.isAuthenticated;
  }

  /// 获取HTTP服务实例
  HttpService get httpService {
    _checkInitialized();
    return _httpService;
  }

  /// 获取TokenManager实例
  TokenManager get tokenManager {
    _checkInitialized();
    return _tokenManager;
  }

  // API getters (Lazy Initialization)
  UserApi get user {
    _checkInitialized();
    return _userApi ??= _apiFactory.createUserApi();
  }

  PlanApi get plan {
    _checkInitialized();
    return _planApi ??= _apiFactory.createPlanApi();
  }

  OrderApi get order {
    _checkInitialized();
    return _orderApi ??= _apiFactory.createOrderApi();
  }

  SubscriptionApi get subscription {
    _checkInitialized();
    return _subscriptionApi ??= _apiFactory.createSubscriptionApi();
  }

  InviteApi get invite {
    _checkInitialized();
    return _inviteApi ??= _apiFactory.createInviteApi();
  }

  NoticeApi get notice {
    _checkInitialized();
    return _noticeApi ??= _apiFactory.createNoticeApi();
  }

  TicketApi get ticket {
    _checkInitialized();
    return _ticketApi ??= _apiFactory.createTicketApi();
  }

  ConfigApi get config {
    _checkInitialized();
    return _configApi ??= _apiFactory.createConfigApi();
  }

  PaymentApi get payment {
    _checkInitialized();
    return _paymentApi ??= _apiFactory.createPaymentApi();
  }

  AuthApi get auth {
    _checkInitialized();
    return _authApi ??= _apiFactory.createAuthApi();
  }

  /// 获取基础URL
  String? get baseUrl => _isInitialized ? _httpService.baseUrl : null;

  /// 便捷登录方法
  Future<bool> loginWithCredentials(String email, String password) async {
    try {
      final token = await auth.login(email, password);
      if (token != null) {
        await saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      if (e is XBoardException) {
        rethrow;
      }
      throw AuthException('Login failed: $e');
    }
  }

  /// 登出
  Future<void> logout() async {
    await auth.logout();
    await clearToken();
  }

  /// 释放SDK资源并重置状态
  void dispose() {
    if (_isInitialized) {
      _tokenManager.dispose();
      _httpService.dispose();
      
      // Reset all lazy loaded APIs
      _userApi = null;
      _planApi = null;
      _orderApi = null;
      _subscriptionApi = null;
      _inviteApi = null;
      _noticeApi = null;
      _ticketApi = null;
      _configApi = null;
      _paymentApi = null;
      _authApi = null;

      _isInitialized = false;
      SdkLogger.i('XBoardSDK disposed');
    }
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw ConfigException('XBoardSDK is not initialized. Call initialize() first.');
    }
  }
}
