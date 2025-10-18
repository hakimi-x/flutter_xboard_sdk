import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证状态枚举
enum AuthState {
  /// 未认证
  unauthenticated,
  /// 已认证
  authenticated,
}

/// Token管理器（极简版）
/// 
/// 负责token的存储、读取和认证状态管理
/// Token永久有效，不处理过期和刷新
/// 
/// 使用示例：
/// ```dart
/// // 创建持久化存储的管理器（默认）
/// final manager = TokenManager();
/// 
/// // 或创建内存存储的管理器（测试用）
/// final manager = TokenManager.memory();
/// 
/// // 保存token
/// await manager.saveToken('your_token');
/// 
/// // 获取token
/// final token = await manager.getToken();
/// 
/// // 监听认证状态
/// manager.authStateStream.listen((state) {
///   print('Auth state: $state');
/// });
/// ```
class TokenManager {
  static const String _storageKey = 'xboard_token';
  
  /// 是否使用内存存储（测试模式）
  final bool _useMemoryStorage;
  
  /// 内存存储的token
  String? _memoryToken;
  
  /// 认证状态流控制器
  final StreamController<AuthState> _authStateController = 
      StreamController<AuthState>.broadcast();
  
  /// 当前认证状态
  AuthState _currentState = AuthState.unauthenticated;
  
  /// 缓存的token，避免频繁读取存储
  String? _cachedToken;

  /// 创建持久化存储的TokenManager（默认）
  TokenManager() : _useMemoryStorage = false {
    _initializeTokenState();
  }
  
  /// 创建内存存储的TokenManager（测试用）
  TokenManager.memory() : _useMemoryStorage = true {
    _initializeTokenState();
  }

  /// 认证状态流
  Stream<AuthState> get authStateStream => _authStateController.stream;

  /// 当前认证状态
  AuthState get currentState => _currentState;

  /// 是否已认证
  bool get isAuthenticated => _currentState == AuthState.authenticated;

  /// 保存token
  Future<void> saveToken(String token) async {
    try {
      if (_useMemoryStorage) {
        _memoryToken = token;
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, token);
      }
      
      _cachedToken = token;
      _updateAuthState(AuthState.authenticated);
    } catch (e) {
      print('[TokenManager] Failed to save token: $e');
      _updateAuthState(AuthState.unauthenticated);
      rethrow;
    }
  }

  /// 获取token
  Future<String?> getToken() async {
    try {
      // 优先返回缓存的token
      if (_cachedToken != null) {
        return _cachedToken;
      }
      
      // 从存储读取
      if (_useMemoryStorage) {
        _cachedToken = _memoryToken;
      } else {
        final prefs = await SharedPreferences.getInstance();
        _cachedToken = prefs.getString(_storageKey);
      }
      
      // 更新认证状态
      if (_cachedToken != null && _cachedToken!.isNotEmpty) {
        _updateAuthState(AuthState.authenticated);
      } else {
        _updateAuthState(AuthState.unauthenticated);
      }
      
      return _cachedToken;
    } catch (e) {
      print('[TokenManager] Failed to get token: $e');
      return null;
    }
  }

  /// 检查是否有token
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// 清除token
  Future<void> clearToken() async {
    try {
      if (_useMemoryStorage) {
        _memoryToken = null;
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_storageKey);
      }
      
      _cachedToken = null;
      _updateAuthState(AuthState.unauthenticated);
    } catch (e) {
      print('[TokenManager] Failed to clear token: $e');
      rethrow;
    }
  }

  /// 释放资源
  void dispose() {
    _authStateController.close();
  }

  /// 初始化token状态
  Future<void> _initializeTokenState() async {
    try {
      String? token;
      if (_useMemoryStorage) {
        token = _memoryToken;
      } else {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString(_storageKey);
      }
      
      if (token != null && token.isNotEmpty) {
        _cachedToken = token;
        _updateAuthState(AuthState.authenticated);
      } else {
        _updateAuthState(AuthState.unauthenticated);
      }
    } catch (e) {
      print('[TokenManager] Failed to initialize token state: $e');
      _updateAuthState(AuthState.unauthenticated);
    }
  }

  /// 更新认证状态
  void _updateAuthState(AuthState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _authStateController.add(newState);
    }
  }
}
