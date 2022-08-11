import 'package:flutter_quick/models/user_model.dart';
import 'package:sp_util/sp_util.dart';

import 'constants/cache.dart';

class AppState {
  UserModel? user;

  AppState();

  /// 是否登陆
  bool get isLogin => (SpUtil.getString(CacheConstants.token) ?? '').isNotEmpty;
}
