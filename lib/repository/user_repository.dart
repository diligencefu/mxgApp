import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quick/config/config.dart';
import 'package:flutter_quick/constants/cache.dart';
import 'package:flutter_quick/http/dio_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

import '../routes/routes.dart';
import '../utils/helper.dart';

class UserRepository {
  static Future<bool> refresh() async {
    var headers = {
      'Authorization': 'Basic bWFsbC10ZWNobmljaWFuOjEyMzQ1Ng==',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json, text/plain, */*',
      'packageName': 'com.mmt.smartloan',
      'appName': 'SmartLoan',
      'afid': 'smartloan',
      'lang': 'es',
    };
    var request = http.Request(
      'POST',
      Uri.parse('${Config.apiHost}/lsfb-auth/oauth/token'),
    );

    request.bodyFields = {
      'grant_type': 'refresh_token',
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    logger(response.statusCode);

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var res = jsonDecode(data);
      if (res["code"] == "00000") {
        SpUtil.putString(CacheConstants.token, res["data"]["access_token"]);
        // Get.offAllNamed(Routes.main);
        // toast("token刷新成功");
        return true;
      }
      // toast("token刷新失败");

      Get.offAllNamed(Routes.login);

      return false;
    } else {
      // toast("token刷新失败");

      Get.offAllNamed(Routes.login);

      return false;
    }
  }

  /// 我的
  static Future info() async {
    var resp = await DioApi.getInstance().post(
        "/lsfb-artificer/artificer/lsfbArtificer/artificerPersonalData",
        queryParameters: {
          "artificerId": app().state.user!.id,
        });
    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 检查手机号
  static Future checkPhone(dynamic phoneNumber) async {
    var resp = await DioApi.getInstance()
        .get("security/existsByMobile?mobile=$phoneNumber");

    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);
    return null;
  }

  /// 发送验证码
  static Future sendSmsCode(dynamic phoneNumber) async {
    var resp = await DioApi.getInstance().post("security/getVerifyCode",
        data: {"mobile": phoneNumber, "type": 1});

    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 发送验证码
  static Future login(Map<String, String> data) async {
    // var resp = await DioApi.getInstance().post("security/login", data: data);

    var headers = {
      'Authorization': 'Basic bWFsbC10ZWNobmljaWFuOjEyMzQ1Ng==',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json, text/plain, */*',
      'packageName': 'com.mmt.smartloan',
      'appName': 'SmartLoan',
      'afid': 'smartloan',
      'lang': 'es',
    };
    var request = http.Request(
      'POST',
      Uri.parse('${Config.apiHost}security/login'),
    );

    request.bodyFields = data;
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    logger(response.statusCode.toString());
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var res = jsonDecode(data);
      logger(res);
      if (res["code"].toString() == "0") {
        SpUtil.putString(CacheConstants.token, res["data"]["token"]);
        SpUtil.putString(CacheConstants.userId, res["data"]["userId"]);
        SpUtil.putString(CacheConstants.mobile, res["data"]["mobile"]);
        return res["data"];
      } else {
        toast(res["msg"].toString());
        return null;
      }
    }
  }

  static Future register(Map<String, String> data) async {
    var resp = await DioApi.getInstance().post(
      'security/register',
      data: data,
    );
    EasyLoading.dismiss();
    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);
    return null;
  }

  /// 上传
  static Future uploadZip(dynamic params, dynamic formData) async {
    var resp = await DioApi.getInstance().post(
      'time/upload/zip6in1',
      queryParameters: params,
      data: formData,
    );
    EasyLoading.dismiss();
    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);
    return null;
  }
}
