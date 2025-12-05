import '../http/http_service.dart';
import '../../api/interfaces/user_api.dart';
import '../../api/interfaces/plan_api.dart';
import '../../api/interfaces/order_api.dart';
import '../../api/interfaces/subscription_api.dart';
import '../../api/interfaces/invite_api.dart';
import '../../api/interfaces/notice_api.dart';
import '../../api/interfaces/ticket_api.dart';
import '../../api/interfaces/config_api.dart';
import '../../api/interfaces/payment_api.dart';
import '../../api/interfaces/auth_api.dart';

import '../../panels/xboard/xboard_export.dart';
import '../../panels/v2board/apis/v2board_login_api.dart';
import '../../panels/v2board/apis/v2board_register_api.dart';
import '../../panels/v2board/apis/v2board_user_info_api.dart';
import '../../panels/v2board/apis/v2board_send_email_code_api.dart';
import '../../panels/v2board/apis/v2board_reset_password_api.dart';
import '../../panels/v2board/apis/v2board_plan_api.dart';
import '../../panels/v2board/apis/v2board_order_api.dart';
import '../../panels/v2board/apis/v2board_payment_api.dart';
import '../../panels/v2board/apis/v2board_subscription_api.dart';
import '../../panels/v2board/apis/v2board_invite_api.dart';
import '../../panels/v2board/apis/v2board_ticket_api.dart';
import '../../panels/v2board/apis/v2board_notice_api.dart';
import '../../panels/v2board/apis/v2board_config_api.dart';
import '../../panels/xboard/apis/xboard_coupon_api.dart';
import '../../panels/v2board/apis/v2board_coupon_api.dart';

import '../../adapters/xboard/xboard_user_adapter.dart';
import '../../adapters/xboard/xboard_plan_adapter.dart';
import '../../adapters/xboard/xboard_order_adapter.dart';
import '../../adapters/xboard/xboard_subscription_adapter.dart';
import '../../adapters/xboard/xboard_invite_adapter.dart';
import '../../adapters/xboard/xboard_notice_adapter.dart';
import '../../adapters/xboard/xboard_ticket_adapter.dart';
import '../../adapters/xboard/xboard_config_adapter.dart';
import '../../adapters/xboard/xboard_payment_adapter.dart';
import '../../adapters/xboard/xboard_auth_adapter.dart';

import '../../adapters/v2board/v2board_user_adapter.dart';
import '../../adapters/v2board/v2board_plan_adapter.dart';
import '../../adapters/v2board/v2board_order_adapter.dart';
import '../../adapters/v2board/v2board_subscription_adapter.dart';
import '../../adapters/v2board/v2board_invite_adapter.dart';
import '../../adapters/v2board/v2board_notice_adapter.dart';
import '../../adapters/v2board/v2board_ticket_adapter.dart';
import '../../adapters/v2board/v2board_config_adapter.dart';
import '../../adapters/v2board/v2board_payment_adapter.dart';
import '../../adapters/v2board/v2board_auth_adapter.dart';

import 'panel_type.dart';

class ApiFactory {
  final PanelType _panelType;
  final HttpService _httpService;

  ApiFactory(this._panelType, this._httpService);

  UserApi createUserApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardUserAdapter(XBoardUserInfoApi(_httpService));
      case PanelType.v2board:
        return V2BoardUserAdapter(V2BoardUserInfoApi(_httpService));
    }
  }

  PlanApi createPlanApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardPlanAdapter(XBoardPlanApi(_httpService));
      case PanelType.v2board:
        return V2BoardPlanAdapter(V2BoardPlanApi(_httpService));
    }
  }

  OrderApi createOrderApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardOrderAdapter(
          XBoardOrderApi(_httpService),
          XBoardCouponApi(_httpService),
        );
      case PanelType.v2board:
        return V2BoardOrderAdapter(
          V2BoardOrderApi(_httpService),
          V2BoardCouponApi(_httpService),
        );
    }
  }

  SubscriptionApi createSubscriptionApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardSubscriptionAdapter(XBoardSubscriptionApi(_httpService));
      case PanelType.v2board:
        return V2BoardSubscriptionAdapter(V2BoardSubscriptionApi(_httpService));
    }
  }

  InviteApi createInviteApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardInviteAdapter(XBoardInviteApi(_httpService));
      case PanelType.v2board:
        return V2BoardInviteAdapter(V2BoardInviteApi(_httpService));
    }
  }

  NoticeApi createNoticeApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardNoticeAdapter(XBoardNoticeApi(_httpService));
      case PanelType.v2board:
        return V2BoardNoticeAdapter(V2BoardNoticeApi(_httpService));
    }
  }

  TicketApi createTicketApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardTicketAdapter(XBoardTicketApi(_httpService));
      case PanelType.v2board:
        return V2BoardTicketAdapter(V2BoardTicketApi(_httpService));
    }
  }

  ConfigApi createConfigApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardConfigAdapter(XBoardConfigApi(_httpService));
      case PanelType.v2board:
        return V2BoardConfigAdapter(V2BoardConfigApi(_httpService));
    }
  }

  PaymentApi createPaymentApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardPaymentAdapter(XBoardPaymentApi(_httpService));
      case PanelType.v2board:
        return V2BoardPaymentAdapter(V2BoardPaymentApi(_httpService));
    }
  }

  AuthApi createAuthApi() {
    switch (_panelType) {
      case PanelType.xboard:
        return XBoardAuthAdapter(
          XBoardLoginApi(_httpService),
          XBoardRegisterApi(_httpService),
          XBoardSendEmailCodeApi(_httpService),
          XBoardResetPasswordApi(_httpService),
        );
      case PanelType.v2board:
        return V2BoardAuthAdapter(
          V2BoardLoginApi(_httpService),
          V2BoardRegisterApi(_httpService),
          V2BoardSendEmailCodeApi(_httpService),
          V2BoardResetPasswordApi(_httpService),
        );
    }
  }
}
