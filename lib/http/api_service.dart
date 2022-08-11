import 'package:dio/dio.dart';
import 'package:flutter_quick/config/config.dart';
import 'package:flutter_quick/enums/view_state_error_type.dart';
import 'package:flutter_quick/repository/user_repository.dart';

enum HttpMethod { get, post, delete, put, patch, formdata }

class ApiService {
  Dio dio;

  ApiService({required this.dio});

  /// get 请求体
  Future<HttpResponse> get(
    String url, {
    dynamic data,
  }) {
    return _sendRequest(
      url,
      HttpMethod.get,
      data: data,
    );
  }

  /// post 请求体
  Future<HttpResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _sendRequest(
      url,
      HttpMethod.post,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// delete 请求体
  Future<HttpResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _sendRequest(
      url,
      HttpMethod.delete,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// put 请求体
  Future<HttpResponse> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _sendRequest(
      url,
      HttpMethod.put,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// 发送请求
  Future<HttpResponse> _sendRequest(
    String url,
    HttpMethod method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response? response;

      /// GET

      if (method == HttpMethod.get) {
        if (data == null) {
          response = await dio.get(url);
        } else {
          response = await dio.get(
            url,
            queryParameters: data,
          );
        }
      }

      ///  POST
      if (method == HttpMethod.post) {
        if (data == null) {
          response = await dio.post(
            url,
            queryParameters: queryParameters,
          );
        } else {
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        }
      }

      ///  DELETE
      if (method == HttpMethod.delete) {
        if (data == null) {
          response = await dio.delete(url);
        } else {
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        }
      }

      ///  PUT
      if (method == HttpMethod.put) {
        if (data == null) {
          response = await dio.put(url);
        } else {
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        }
      }

      /// 接口响应成功
      if (response!.statusCode == 200) {
        String codeFieldName = Config.codeFiledName;
        String messageFiledName = Config.messageFiledName;
        var resultCode = response.data[codeFieldName];
        var message = response.data[messageFiledName];

        /// 接口返回状态码是未登录 code=401 token失效 跳到登录
        if (Config.unauthorizedCodeValues.contains(resultCode)) {
          // final AppLogic appLogic = Get.put(AppLogic());
          // appLogic.logout();
          // Get.offAllNamed(Routes.login);
          UserRepository.refresh();
        }

        return HttpResponse(
          message: message,
          sucess: Config.successCodeValues.contains(resultCode), //、 code == 200
          data: response.data["data"],
        );
      }

      /// http状态吗为401时 跳到登陆页面
      if (response.statusCode == 401) {
        // final AppLogic appLogic = Get.put(AppLogic());
        // appLogic.logout();
        // Get.offAllNamed(Routes.login);
        UserRepository.refresh();
      }

      /// 接口请求失败 http状态码 != 200
      var type = ViewStateErrorType.defaultError;
      if (response.statusCode == 401 || response.statusCode == 402) {
        type = ViewStateErrorType.unauthorized;
      }
      if (response.statusCode == 500) {
        type = ViewStateErrorType.serverError;
      }

      throw HttpException(
        type: type,
        code: response.statusCode,
        message: response.data.toString(),
      );
    } catch (e) {
      if (e is DioError && e.message == "Http status error [401]") {
        // final AppLogic appLogic = Get.put(AppLogic());
        // appLogic.logout();
        // Get.offAllNamed(Routes.login);
        UserRepository.refresh();
      }

      throw e;
    }
  }
}

class HttpResponse {
  HttpResponse({
    required this.sucess,
    required this.message,
    this.data,
  });

  //、 是否请求成功
  bool sucess;

  // 接口的所有返回值
  dynamic data;

  // 接口对应的messahe

  String message = "";
}

class HttpException implements Exception {
  HttpException({
    this.code,
    this.type = ViewStateErrorType.defaultError,
    this.message,
  });

  int? code;

  ViewStateErrorType? type;

  String? message;

  @override
  String toString() {
    return 'GlobalException code: $code, message: $message, type: $type';
  }
}
