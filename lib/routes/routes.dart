import 'package:flutter_quick/modules/auth/login/view.dart';
import 'package:flutter_quick/modules/auth/permission/view.dart';
import 'package:flutter_quick/modules/auth/register/view.dart';
import 'package:flutter_quick/modules/splash/view.dart';
import 'package:flutter_quick/modules/webview/view.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

import '../constants/cache.dart';
import 'middlewares/auth_middleware.dart';

class Routes {
  static const String login = "/login";
  static const String permission = "/permission";
  static const String register = "/register";
  static const String splash = "/splash";
  static const String webview = "/webview";
  // static const String max = "/max";

  /// 初始化路由
  static String initialRoute = webview;
  // static String initialRoute = login;

  static final pages = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: permission, page: () => PermissionPage()),
    GetPage(name: register, page: () => RegisterPage()),
    GetPage(
        middlewares: [AuthMiddleware()],
        name: splash,
        page: () => SplashPage()),
    GetPage(name: webview, page: () => WebviewPage()),
  ];
}
