import 'package:flutter/material.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:get/get.dart';

import '../../utils/helper.dart';


/// 检查是否登录
class AuthMiddleware extends GetMiddleware {
  // priority 数字小优先级高

  @override
  RouteSettings? redirect(String? route) {
    if (app().state.isLogin) {
      return null;
    }
    return const RouteSettings(name: Routes.login);
  }
}
