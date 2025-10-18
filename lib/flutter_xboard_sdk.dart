// XBoard SDK for Flutter (简化版)

// 导出核心SDK类
export 'src/xboard_sdk.dart';

// 导出配置类
export 'src/config/http_config.dart';

// 导出服务类
export 'src/services/http_service.dart';

// 导出Token管理类（极简版 - 只有2个文件）
export 'src/core/token/token_manager.dart';
export 'src/core/token/auth_interceptor.dart';

// 导出异常类
export 'src/exceptions/xboard_exceptions.dart';

// 导出通用模型
export 'src/common/models/api_response.dart';

// 导出功能模块API
export 'src/features/order/order_api.dart';
export 'src/features/order/order_models.dart';

export 'src/features/plan/plan_api.dart';
export 'src/features/plan/plan_models.dart';

export 'src/features/ticket/ticket_api.dart';
export 'src/features/ticket/ticket_models.dart';

export 'src/features/user_info/user_info_api.dart';
export 'src/features/user_info/user_info_models.dart';

export 'src/features/app/app_api.dart';
export 'src/features/app/app_models.dart';

export 'src/features/balance/balance_api.dart';
export 'src/features/balance/balance_models.dart';

export 'src/features/config/config_api.dart';
export 'src/features/config/config_models.dart';

export 'src/features/coupon/coupon_api.dart';
export 'src/features/coupon/coupon_models.dart';

export 'src/features/invite/invite_api.dart';
export 'src/features/invite/invite_models.dart';

export 'src/features/notice/notice_api.dart';
export 'src/features/notice/notice_models.dart';

export 'src/features/payment/payment_api.dart';
export 'src/features/payment/payment_models.dart';

export 'src/features/subscription/subscription_api.dart';
export 'src/features/subscription/subscription_models.dart';
