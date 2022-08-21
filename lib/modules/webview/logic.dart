import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:sp_util/sp_util.dart';
import '../../constants/cache.dart';
import '../../repository/user_repository.dart';
import '../../utils/helper.dart';
import 'state.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:liveness_plugin/liveness_plugin.dart';

class WebviewLogic extends GetxController with LivenessDetectionCallback {
  final WebviewState state = WebviewState();
  static const channel = MethodChannel("timesdk_plugin");
  dynamic data;

  @override
  void onGetDetectionResult(bool isSuccess, Map resultMap) {
    var params = data;
    if (!isSuccess) {
      params["result"] = "fail";
      params["msg"] = resultMap["message"];
      params["data"] = {"errorMsg": resultMap["message"]};
      Map<String, dynamic> callbackMap = params;
      callH5("webViewFaceImg", callbackMap);
      return;
    }
    String image = resultMap["base64Image"];

    params["data"]["livenessId"] = resultMap["resultMap"];
    params["data"]["file"] = image;
    params["result"] = "ok";
    Map<String, dynamic> callbackMap = params;
    callH5("webViewFaceImg", callbackMap);
  }

  @override
  void onInit() {
    var arg = Get.arguments;
    if (arg != null) {
      state.url = arg["url"];
      state.title = arg["title"];
      update();
    }
    super.onInit();

    LivenessPlugin.initSDK(
        '54e03a28ec301bb8', '36181f76c174e848', Market.Mexico);
    channel.setMethodCallHandler((call) async {
      // logger("接收到call: ${call.method} arguments: ${call.arguments}");

      var callbackName = "webViewToTime";
      var arguments = call.arguments;

      var path = arguments['file'];
      String fileName = path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          path,
          filename: fileName,
        )
      });
      UserRepository.uploadZip(
              {'md5': arguments['md5'], 'orderNo': arguments['orderNo']},
              formData)
          .then((value) {
        logger(value);
        if (value != null && arguments['isSubmit'] == true) {
          var result = "";
          if (call.method == "onTimeFailCallBack") {
            result = "fail";
          } else {
            result = "success";
          }
          var callbackMap = {
            "action": "timeSDK",
            "result": result,
            "msg": "",
            "id": data["id"].toString(),
            "data": {
              "orderNo": data["data"]["orderNo"].toString(),
              "userId": SpUtil.getString(CacheConstants.userId),
              "isSubmit": data["data"]["isSubmit"],
              "appList": data["data"]["appList"],
              "sms": data["data"]["appList"],
              "exif": data["data"]["exif"],
              "device": data["data"]["device"],
              "contact": data["data"]["contact"],
              "location": data["data"]["location"]
            },
            "callback": callbackName
          };
          callH5(callbackName, callbackMap);
        }
      });
    });
  }

  void callH5(String callbackName, Map<String, dynamic> callbackMap) {
    logger("$callbackName(${json.encode(callbackMap)})");
    state.flutterWebViewPlugin
        .evalJavascript("$callbackName(${json.encode(callbackMap)})");
  }

  void callLivenessDetection(dynamic parmas) {
    data = parmas;
    LivenessPlugin.startLivenessDetection(this);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void errorHandler(e) {
    print("=====TimesdkException=====");
    print(e.toString());
  }

  void collectMessage(dynamic params) {
    data = params;
    var param = {
      "action": "timeSDK",
      "id": data["id"].toString(),
      "data": {
        "orderNo": data["data"]["orderNo"].toString(),
        "userId": SpUtil.getString(CacheConstants.userId),
        "isSubmit": data["data"]["isSubmit"],
        "appList": data["data"]["appList"],
        "sms": data["data"]["appList"],
        "exif": data["data"]["exif"],
        "device": data["data"]["device"],
        "contact": data["data"]["contact"],
        "location": data["data"]["location"]
      },
      "callback": "webViewToTime"
    };
    channel.invokeMethod('collectMessage', json.encode(param));
  }
}
