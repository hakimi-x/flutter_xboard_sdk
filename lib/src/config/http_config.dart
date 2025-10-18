/// HTTP 配置类
/// 
/// 用于管理 SDK 的 HTTP 相关配置，包括：
/// - User-Agent 配置
/// - 响应混淆配置
/// - 证书固定配置
/// - 代理配置
class HttpConfig {
  /// User-Agent 字符串
  /// 
  /// 如果为 null，将使用默认的 User-Agent
  /// 建议从配置文件或配置提供者读取此值
  final String? userAgent;

  /// 响应混淆前缀
  /// 
  /// 某些服务端会在响应中添加混淆前缀（如 Caddy 反代）
  /// 例如：'OBFS_9K8L7M6N_'
  /// 如果为 null，将不进行反混淆处理
  final String? obfuscationPrefix;

  /// 是否启用证书固定（Certificate Pinning）
  /// 
  /// 默认为 false，使用标准的 SSL 验证
  /// 如果为 true，需要提供 certificatePath
  final bool enableCertificatePinning;

  /// 证书文件路径（相对于 assets 目录）
  /// 
  /// 从配置文件读取：xboard.config.yaml -> security.certificate.path
  /// 例如：'packages/flutter_xboard_sdk/assets/cer/client-cert.crt'
  final String? certificatePath;

  /// 是否忽略证书主机名验证
  /// 
  /// ⚠️ 警告：仅在开发/测试环境使用，生产环境应该为 false
  /// 默认为 false，进行标准的主机名验证
  final bool ignoreCertificateHostname;

  /// HTTP 代理 URL
  /// 
  /// 格式：'host:port' 或 'http://host:port'
  /// 如果为 null，将不使用代理
  final String? proxyUrl;

  /// 是否启用自动反混淆
  /// 
  /// 如果为 true，当检测到混淆前缀时会自动反混淆
  /// 如果为 false，即使设置了 obfuscationPrefix 也不会进行反混淆
  final bool enableAutoDeobfuscation;

  /// 连接超时时间（秒）
  final int connectTimeoutSeconds;

  /// 接收超时时间（秒）
  final int receiveTimeoutSeconds;

  /// 发送超时时间（秒）
  final int sendTimeoutSeconds;

  const HttpConfig({
    this.userAgent,
    this.obfuscationPrefix,
    this.enableCertificatePinning = false,
    this.certificatePath,
    this.ignoreCertificateHostname = false,
    this.proxyUrl,
    this.enableAutoDeobfuscation = true,
    this.connectTimeoutSeconds = 30,
    this.receiveTimeoutSeconds = 30,
    this.sendTimeoutSeconds = 30,
  });

  /// 创建默认配置
  factory HttpConfig.defaultConfig() {
    return const HttpConfig(
      userAgent: 'FlClash-XBoard-SDK/1.0',
      enableAutoDeobfuscation: true,
      enableCertificatePinning: false,
    );
  }

  /// 创建开发环境配置
  /// 
  /// ⚠️ 警告：此配置仅用于开发/测试，不应在生产环境使用
  factory HttpConfig.development({
    String? userAgent,
    String? proxyUrl,
  }) {
    return HttpConfig(
      userAgent: userAgent ?? 'FlClash-XBoard-SDK/1.0-dev',
      proxyUrl: proxyUrl,
      enableCertificatePinning: false,
      ignoreCertificateHostname: true, // 开发环境可以忽略主机名验证
      enableAutoDeobfuscation: true,
    );
  }

  /// 创建生产环境配置
  factory HttpConfig.production({
    required String userAgent,
    String? obfuscationPrefix,
    bool enableCertificatePinning = false,
    String? certificatePath,
  }) {
    // 生产环境的安全检查
    if (enableCertificatePinning && certificatePath == null) {
      throw ArgumentError(
        'enableCertificatePinning is true but certificatePath is null. '
        'Certificate pinning requires a certificate path from config file.',
      );
    }

    return HttpConfig(
      userAgent: userAgent,
      obfuscationPrefix: obfuscationPrefix,
      enableCertificatePinning: enableCertificatePinning,
      certificatePath: certificatePath,
      ignoreCertificateHostname: false, // 生产环境必须验证主机名
      enableAutoDeobfuscation: obfuscationPrefix != null,
    );
  }

  /// 从配置提供者创建（与主项目集成）
  /// 
  /// 示例：
  /// ```dart
  /// final config = await HttpConfig.fromConfigProvider(
  ///   getUserAgent: () => UserAgentConfig.get(UserAgentScenario.apiEncrypted),
  ///   getObfuscationPrefix: () => ConfigFileLoaderHelper.getObfuscationPrefix(),
  ///   getCertificatePath: () => ConfigFileLoaderHelper.getCertificatePath(),
  ///   enableCertificatePinning: () => ConfigFileLoaderHelper.isCertificatePinningEnabled(),
  /// );
  /// ```
  static Future<HttpConfig> fromConfigProvider({
    required Future<String> Function() getUserAgent,
    Future<String?> Function()? getObfuscationPrefix,
    Future<String?> Function()? getCertificatePath,
    Future<bool> Function()? enableCertificatePinning,
    String? proxyUrl,
  }) async {
    final userAgent = await getUserAgent();
    final obfuscationPrefix = getObfuscationPrefix != null 
        ? await getObfuscationPrefix() 
        : null;
    final certPath = getCertificatePath != null
        ? await getCertificatePath()
        : null;
    final certPinning = enableCertificatePinning != null
        ? await enableCertificatePinning()
        : false;

    return HttpConfig(
      userAgent: userAgent,
      obfuscationPrefix: obfuscationPrefix,
      proxyUrl: proxyUrl,
      enableCertificatePinning: certPinning,
      certificatePath: certPath,
      enableAutoDeobfuscation: obfuscationPrefix != null,
    );
  }

  /// 复制配置并修改部分字段
  HttpConfig copyWith({
    String? userAgent,
    String? obfuscationPrefix,
    bool? enableCertificatePinning,
    String? certificatePath,
    bool? ignoreCertificateHostname,
    String? proxyUrl,
    bool? enableAutoDeobfuscation,
    int? connectTimeoutSeconds,
    int? receiveTimeoutSeconds,
    int? sendTimeoutSeconds,
  }) {
    return HttpConfig(
      userAgent: userAgent ?? this.userAgent,
      obfuscationPrefix: obfuscationPrefix ?? this.obfuscationPrefix,
      enableCertificatePinning: enableCertificatePinning ?? this.enableCertificatePinning,
      certificatePath: certificatePath ?? this.certificatePath,
      ignoreCertificateHostname: ignoreCertificateHostname ?? this.ignoreCertificateHostname,
      proxyUrl: proxyUrl ?? this.proxyUrl,
      enableAutoDeobfuscation: enableAutoDeobfuscation ?? this.enableAutoDeobfuscation,
      connectTimeoutSeconds: connectTimeoutSeconds ?? this.connectTimeoutSeconds,
      receiveTimeoutSeconds: receiveTimeoutSeconds ?? this.receiveTimeoutSeconds,
      sendTimeoutSeconds: sendTimeoutSeconds ?? this.sendTimeoutSeconds,
    );
  }

  @override
  String toString() {
    return 'HttpConfig('
        'userAgent: $userAgent, '
        'obfuscationPrefix: ${obfuscationPrefix != null ? "***" : "null"}, '
        'enableCertificatePinning: $enableCertificatePinning, '
        'ignoreCertificateHostname: $ignoreCertificateHostname, '
        'proxyUrl: $proxyUrl'
        ')';
  }
}

