import 'package:dio/dio.dart' hide Lock;
import 'package:flutter_quick/config/config.dart';

import 'api_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/log_interceptor.dart';

///dio框架的封装

class DioApi {
  static late ApiService _apiService;
  // ignore: unused_field
  static late DioApi _singleton;

  DioApi() {
    var options = BaseOptions(
      connectTimeout: 200000,
      receiveTimeout: 200000,
      baseUrl: Config.apiHost,
    );
    Dio dio = Dio(options);
    if (Config.isDebug) {
      dio.interceptors.add(
        DioLogInterceptor(
          requestBody: true,
          requestHeader: false,
          responseBody: true,
          responseHeader: false,
        ),
      );
    }

    dio.interceptors.add(AuthInterceptor());
    _apiService = ApiService(dio: dio);
  }

  /// 单例模式
  static ApiService getInstance() {
    _singleton = DioApi();

    return _getService();
  }

  static ApiService _getService() {
    return _apiService;
  }
}
