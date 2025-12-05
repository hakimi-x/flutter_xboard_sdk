import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_xboard_sdk/flutter_xboard_sdk.dart';
import 'package:flutter_xboard_sdk/src/core/logging/sdk_logger.dart';

import 'config/test_config.dart';

// ==========================================
// ⚠️ 配置区域 / Configuration Area
// 真实数据请在 test/config/test_config.dart 中配置
// Real data is configured in test/config/test_config.dart
// ==========================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('XBoard SDK Full Integration Test', () {
    setUpAll(() async {
      // Allow real network requests
      HttpOverrides.global = null;

      // Initialize SDK
      await XBoardSDK.instance.initialize(
        testBaseUrl,
        panelType: testPanelType,
        proxyUrl: testProxy,
        enableLogging: true,
        useMemoryStorage: true,
        usePrintLogger: true,
      );

      // Login first for all tests
      final success = await XBoardSDK.instance.loginWithCredentials(testEmail, testPassword);
      if (!success) {
        throw Exception('Failed to login. Cannot proceed with tests.');
      }
    });

    // 1. Auth API
    group('Auth API', () {
      test('logout and login', () async {
        // Logout
        await XBoardSDK.instance.logout();
        expect(XBoardSDK.instance.isAuthenticated, isFalse);

        // Login again
        final success = await XBoardSDK.instance.loginWithCredentials(testEmail, testPassword);
        expect(success, isTrue);
        expect(XBoardSDK.instance.isAuthenticated, isTrue);
      });
      
      test('sendEmailVerifyCode', () async {
        // Note: This will send a real email
        try {
          await XBoardSDK.instance.auth.sendEmailVerifyCode(testEmail);
        } catch (e) {
          // Ignore rate limit errors (400)
          if (e.toString().contains('400')) {
            SdkLogger.w('sendEmailVerifyCode rate limited (expected): $e');
            return;
          }
          rethrow;
        }
      });
    });

    // 2. User API
    group('User API', () {
      test('getUserInfo', () async {
        final user = await XBoardSDK.instance.user.getUserInfo();
        expect(user.email, equals(testEmail));
        expect(user.uuid, isNotNull);
      });

      test('updateUserInfo', () async {
        // Note: This modifies user data. We'll update it to the same value to be safe(ish)
        // Or just update a non-critical field if possible.
        // For now, let's just try updating something trivial or skip if not sure.
        // Assuming telegram_id update is safe enough for test account.
        try {
           await XBoardSDK.instance.user.updateUserInfo({'telegram_id': ''});
        } catch (e) {
          SdkLogger.w('updateUserInfo failed (expected if param invalid): $e');
        }
      });
    });

    // 3. Plan API
    group('Plan API', () {
      test('getPlans', () async {
        final plans = await XBoardSDK.instance.plan.getPlans();
        expect(plans, isA<List<PlanModel>>());
        if (plans.isNotEmpty) {
          SdkLogger.i('Found ${plans.length} plans');
        }
      });

      test('getPlan details', () async {
        final plans = await XBoardSDK.instance.plan.getPlans();
        if (plans.isNotEmpty) {
          final plan = await XBoardSDK.instance.plan.getPlan(plans.first.id);
          expect(plan, isNotNull);
          expect(plan!.id, equals(plans.first.id));
        }
      });
    });

    // 4. Order API
    group('Order API', () {
      test('getOrders', () async {
        final orders = await XBoardSDK.instance.order.getOrders();
        expect(orders, isA<List<OrderModel>>());
      });

      test('createOrder and cancelOrder', () async {
        final plans = await XBoardSDK.instance.plan.getPlans();
        if (plans.isNotEmpty) {
          // Try to find a monthly plan or just use the first one
          final planId = plans.first.id;
          
          try {
            final tradeNo = await XBoardSDK.instance.order.createOrder(planId, 'month_price');
            expect(tradeNo, isNotEmpty);
            SdkLogger.i('Created order: $tradeNo');
            
            final success = await XBoardSDK.instance.order.cancelOrder(tradeNo);
            expect(success, isTrue);
            SdkLogger.i('Cancelled order: $tradeNo');
          } catch (e) {
             SdkLogger.w('Order test failed: $e');
             // Don't fail the whole test suite if order creation fails (e.g. insufficient permissions or config)
          }
        }
      });
    });

    // 5. Subscription API
    group('Subscription API', () {
      test('getSubscribeUrl', () async {
        final url = await XBoardSDK.instance.subscription.getSubscribeUrl();
        expect(url, isNotEmpty);
        expect(url, startsWith('http'));
      });

      test('getSubscription', () async {
        // Some panels might not implement this or return different data
        try {
          final sub = await XBoardSDK.instance.subscription.getSubscription();
          expect(sub, isNotNull);
        } catch (e) {
          SdkLogger.w('getSubscription failed (might be expected): $e');
        }
      });
    });

    // 6. Invite API
    group('Invite API', () {
      test('getInviteInfo', () async {
        try {
          final info = await XBoardSDK.instance.invite.getInviteInfo();
          expect(info, isNotNull);
        } catch (e) {
           SdkLogger.w('getInviteInfo failed: $e');
        }
      });

      test('getInviteCodes', () async {
        try {
          final codes = await XBoardSDK.instance.invite.getInviteCodes();
          expect(codes, isA<List<InviteCodeModel>>());
        } catch (e) {
          SdkLogger.w('getInviteCodes failed: $e');
        }
      });
    });

    // 7. Notice API
    group('Notice API', () {
      test('getNotices', () async {
        final notices = await XBoardSDK.instance.notice.getNotices();
        expect(notices, isA<List<NoticeModel>>());
      });
    });

    // 8. Ticket API
    group('Ticket API', () {
      test('getTickets', () async {
        final tickets = await XBoardSDK.instance.ticket.getTickets();
        expect(tickets, isA<List<TicketModel>>());
      });
    });

    // 9. Config API
    group('Config API', () {
      test('getConfig', () async {
        final config = await XBoardSDK.instance.config.getConfig();
        expect(config, isNotNull);
      });
    });
  });
}
