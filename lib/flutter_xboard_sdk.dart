// XBoard SDK for Flutter - 策略模式架构

// ========== 核心SDK ==========
export 'src/xboard_sdk.dart';

// ========== 核心基础设施 ==========
// HTTP配置 (用户可能需要配置代理)
export 'src/core/http/http_config.dart';

// 面板类型
export 'src/core/factory/panel_type.dart';

// 异常
export 'src/core/exceptions/xboard_exceptions.dart';

// 通用模型
export 'src/core/models/api_response.dart';

// ========== 统一 API 层 ==========
// 接口
export 'src/api/interfaces/auth_api.dart';
export 'src/api/interfaces/config_api.dart';
export 'src/api/interfaces/invite_api.dart';
export 'src/api/interfaces/notice_api.dart';
export 'src/api/interfaces/order_api.dart';
export 'src/api/interfaces/payment_api.dart';
export 'src/api/interfaces/plan_api.dart';
export 'src/api/interfaces/subscription_api.dart';
export 'src/api/interfaces/ticket_api.dart';
export 'src/api/interfaces/user_api.dart';

// 模型
export 'src/api/models/config_model.dart';
export 'src/api/models/invite_model.dart';
export 'src/api/models/notice_model.dart';
export 'src/api/models/order_model.dart';
export 'src/api/models/payment_model.dart';
export 'src/api/models/plan_model.dart';
export 'src/api/models/subscription_model.dart';
export 'src/api/models/ticket_model.dart';
export 'src/api/models/user_model.dart';
export 'src/api/models/coupon_model.dart';

