import 'package:dio/dio.dart' hide Lock;
import 'package:dio_proxy_plugin/dio_proxy_plugin.dart';
import 'package:flutter/services.dart';
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
      connectTimeout: 2000,
      receiveTimeout: 2000,
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
      setProxy(dio);
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

  static setProxy(Dio dio) async {
    String deviceProxy = '';
    try {
      deviceProxy = await DioProxyPlugin.deviceProxy;
    } on PlatformException {
      print('Failed to get system proxy.');
    }
    if (deviceProxy.isNotEmpty) {
      var arrProxy = deviceProxy.split(':');
      final port = int?.tryParse(arrProxy[1]) ?? 8888;
      //设置dio proxy
      var httpProxyAdapter = HttpProxyAdapter(ipAddr: arrProxy[0], port: port);
      dio.httpClientAdapter = httpProxyAdapter;
    }
  }
}
