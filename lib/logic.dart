import 'package:flutter_quick/repository/user_repository.dart';
import 'package:flutter_quick/state.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

import 'constants/cache.dart';
import 'models/user_model.dart';
import 'routes/routes.dart';

/// 全局逻辑 用于获取用户状态、主题设置等信息
class AppLogic extends GetxController {
  final state = AppState();

  @override
  onInit() async {
    super.onInit();

    /// 从缓存设置用户信息
    var userCache = SpUtil.getObject(CacheConstants.user);
    if (userCache != null) {
      state.user = UserModel.fromJson(userCache as Map<String, dynamic>);

      update();
    }

    // updateUser();
  }

  /// 更新用户信息
  Future updateUser() async {
    // var data = await UserRepository.userInfo();
    // if (data != null) {
    //   SpUtil.putObject(CacheConstants.user, data.toJson());
    //   state.user = data;
    // }

    // update();
  }

  /// 退出
  logout() async {
    Get.offAllNamed(Routes.login);
    SpUtil.clear();
  }
}
