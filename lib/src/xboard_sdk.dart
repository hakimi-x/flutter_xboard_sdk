import 'services/http_service.dart';
import 'core/token/token_manager.dart';
import 'config/http_config.dart';

import 'features/payment/payment_api.dart';
import 'features/plan/plan_api.dart';
import 'features/ticket/ticket_api.dart';
import 'exceptions/xboard_exceptions.dart';
import 'features/user_info/user_info_api.dart';
import 'features/balance/balance_api.dart';
import 'features/coupon/coupon_api.dart';
import 'features/notice/notice_api.dart';
import 'features/order/order_api.dart';

// Modularized auth features
import 'features/app/app_api.dart';
import 'features/invite/invite_api.dart';
import 'features/auth/login/login_api.dart';
import 'features/auth/register/register_api.dart';
import 'features/auth/send_email_code/send_email_code_api.dart';
import 'features/auth/reset_password/reset_password_api.dart';
import 'features/config/config_api.dart';
import 'features/subscription/subscription_api.dart';

/// XBoard SDK主类（极简版）
/// 提供对XBoard API的统一访问接口
/// 
/// Token永久有效，不处理过期和刷新
/// 
/// 使用示例：
/// ```dart
/// // 1. 初始化SDK
/// await XBoardSDK.instance.initialize('https://your-api.com');
/// 
/// // 2. 登录
/// final success = await XBoardSDK.instance.loginWithCredentials(
///   'user@example.com',
///   'password',
/// );
/// 
/// // 3. 使用API
/// final userInfo = await XBoardSDK.instance.userInfo.getUserInfo();
/// 
/// // 4. 监听认证状态
/// XBoardSDK.instance.authStateStream.listen((state) {
///   print('Auth state: $state');
/// });
/// ```
class XBoardSDK {
  static XBoardSDK? _instance;
  static XBoardSDK get instance => _instance ??= XBoardSDK._internal();

  XBoardSDK._internal();

  late HttpService _httpService;
  late TokenManager _tokenManager;

  late PaymentApi _paymentApi;
  late PlanApi _planApi;
  late TicketApi _ticketApi;
  late UserInfoApi _userInfoApi;

  // Modularized auth features
  late LoginApi _loginApi;
  late RegisterApi _registerApi;
  late SendEmailCodeApi _sendEmailCodeApi;
  late ResetPasswordApi _resetPasswordApi;
  late ConfigApi _configApi;
  late SubscriptionApi _subscriptionApi;
  late BalanceApi _balanceApi;
  late CouponApi _couponApi;
  late NoticeApi _noticeApi;
  late OrderApi _orderApi;
  late InviteApi _inviteApi;
  late AppApi _appApi;

  bool _isInitialized = false;

  /// 初始化SDK
  /// 
  /// [baseUrl] XBoard服务器的基础URL
  /// [httpConfig] HTTP配置（User-Agent、混淆前缀、证书等）
  /// [useMemoryStorage] 是否使用内存存储（默认false，测试时可设为true）
  ///
  /// 示例:
  /// ```dart
  /// // 生产环境：使用持久化存储
  /// await XBoardSDK.instance.initialize(
  ///   'https://your-xboard-domain.com',
  ///   httpConfig: HttpConfig.production(
  ///     userAgent: 'FlClash-XBoard-SDK/1.0',
  ///   ),
  /// );
  /// 
  /// // 测试环境：使用内存存储
  /// await XBoardSDK.instance.initialize(
  ///   'https://test-api.com',
  ///   useMemoryStorage: true,
  /// );
  /// ```
  Future<void> initialize(
    String baseUrl, {
    HttpConfig? httpConfig,
    bool useMemoryStorage = false,
  }) async {
    if (baseUrl.isEmpty) {
      throw ConfigException('Base URL cannot be empty');
    }

    // 移除URL末尾的斜杠
    final cleanUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    // 初始化TokenManager（极简版，只需一行）
    _tokenManager = useMemoryStorage ? TokenManager.memory() : TokenManager();

    // 初始化HTTP服务
    final finalHttpConfig = httpConfig ?? HttpConfig.defaultConfig();
    
    _httpService = HttpService(
      cleanUrl, 
      tokenManager: _tokenManager, 
      httpConfig: finalHttpConfig,
    );

    // Initialize API instances
    _paymentApi = PaymentApi(_httpService);
    _planApi = PlanApi(_httpService);
    _ticketApi = TicketApi(_httpService);
    _userInfoApi = UserInfoApi(_httpService);
    _loginApi = LoginApi(_httpService);
    _registerApi = RegisterApi(_httpService);
    _sendEmailCodeApi = SendEmailCodeApi(_httpService);
    _resetPasswordApi = ResetPasswordApi(_httpService);
    _configApi = ConfigApi(_httpService);
    _subscriptionApi = SubscriptionApi(_httpService);
    _balanceApi = BalanceApi(_httpService);
    _couponApi = CouponApi(_httpService);
    _noticeApi = NoticeApi(_httpService);
    _orderApi = OrderApi(_httpService);
    _inviteApi = InviteApi(_httpService);
    _appApi = AppApi(_httpService);

    _isInitialized = true;
  }

  /// 保存Token
  /// [token] 认证令牌（自动添加Bearer前缀）
  Future<void> saveToken(String token) async {
    // 确保token有Bearer前缀
    final fullToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
    await _tokenManager.saveToken(fullToken);
  }

  /// 获取当前Token
  Future<String?> getToken() async {
    return await _tokenManager.getToken();
  }

  /// 清除Token
  Future<void> clearToken() async {
    await _tokenManager.clearToken();
  }

  /// 检查是否有Token
  Future<bool> hasToken() async {
    return await _tokenManager.hasToken();
  }

  /// 检查SDK是否已初始化
  bool get isInitialized => _isInitialized;

  /// 获取认证状态流
  Stream<AuthState> get authStateStream => _tokenManager.authStateStream;

  /// 获取当前认证状态
  AuthState get authState => _tokenManager.currentState;

  /// 是否已认证
  bool get isAuthenticated => _tokenManager.isAuthenticated;

  /// 获取HTTP服务实例（供高级用户使用）
  HttpService get httpService => _httpService;

  /// 获取TokenManager实例（供高级用户使用）
  TokenManager get tokenManager => _tokenManager;

  // API getters
  LoginApi get login => _loginApi;
  RegisterApi get register => _registerApi;
  SendEmailCodeApi get sendEmailCode => _sendEmailCodeApi;
  ResetPasswordApi get resetPassword => _resetPasswordApi;
  ConfigApi get config => _configApi;
  SubscriptionApi get subscription => _subscriptionApi;
  BalanceApi get balance => _balanceApi;
  CouponApi get coupon => _couponApi;
  NoticeApi get notice => _noticeApi;
  OrderApi get order => _orderApi;
  InviteApi get invite => _inviteApi;
  AppApi get app => _appApi;

  /// 支付服务
  PaymentApi get payment => _paymentApi;

  /// 套餐服务
  PlanApi get plan => _planApi;

  /// 工单服务
  TicketApi get ticket => _ticketApi;

  /// 用户信息服务
  UserInfoApi get userInfo => _userInfoApi;

  /// 获取基础URL
  String? get baseUrl => _httpService.baseUrl;

  /// 便捷登录方法
  /// 登录成功后自动保存token
  Future<bool> loginWithCredentials(String email, String password) async {
    try {
      final response = await _loginApi.login(email, password);
      if (response.success == true && response.data != null) {
        final data = response.data!;
        // 优先使用authData，因为它包含完整的Bearer token格式
        final tokenToUse = data.authData ?? data.token;
        if (tokenToUse != null) {
          await saveToken(tokenToUse);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('[XBoardSDK] Login failed: $e');
      return false;
    }
  }

  /// 登出
  Future<void> logout() async {
    await clearToken();
  }

  /// 释放SDK资源
  void dispose() {
    _tokenManager.dispose();
    _httpService.dispose();
  }
}
