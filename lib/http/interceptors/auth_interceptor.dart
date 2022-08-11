import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

import '../../constants/cache.dart';
import '../../utils/helper.dart';

class AuthInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json,*/*';
    options.headers['Content-Type'] = 'application/json; charset=utf-8';
    options.headers['packageName'] = 'com.mmt.smartloan';
    options.headers['appName'] = 'SmartLoan';
    options.headers['afid'] = 'application';
    options.headers['lang'] = 'es';
    String token = SpUtil.getString(CacheConstants.token, defValue: '')!;

    if (token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
      logger(token);
    }

    super.onRequest(options, handler);
  }
}
