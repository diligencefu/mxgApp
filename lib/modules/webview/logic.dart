import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_quick/constants/cache.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
// import 'package:timesdk_plugin/timesdk_plugin.dart';
import '../../utils/helper.dart';
import 'state.dart';

class WebviewLogic extends GetxController {
  final WebviewState state = WebviewState();
  static const channel = MethodChannel("timesdk_plugin");
  dynamic data;
  @override
  void onInit() {
    var arg = Get.arguments;
    if (arg != null) {
      state.url = arg["url"];
      state.title = arg["title"];
      update();
    }
    super.onInit();

    channel.setMethodCallHandler((call) async {
      // logger("接收到call: ${call.method} arguments: ${call.arguments}");

      var callbackName = "webViewToTime";
      // var callbackMap = {
      //   "action": "timeSDK",
      //   "result": "fail",
      //   "msg": "",
      //   "id": call.arguments["json"]["id"],
      //   "data": ""
      // };
      var arguments = call.arguments;

      var result = "";
      if (call.method == "onTimeFailCallBack") {
        result = "fail";
      } else {
        result = "success";
      }

      print(arguments.toString() + "999999");
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
        "callback": "webViewToTime"
      };
      callH5(callbackName, callbackMap);
    });
  }

  void callH5(String callbackName, Map<String, dynamic> callbackMap) {
    logger("$callbackName(${json.encode(callbackMap)})");
    state.controller
        .runJavascript("$callbackName(${json.encode(callbackMap)})");
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

  void call_H5(String callbackName, Map<String, dynamic> callbackMap) {
    logger("==== call h5 ==== \n "
        "callback: $callbackName, \n "
        "callbackMap: $callbackMap \n =============");
    state.controller
        .runJavascript("$callbackName(${json.encode(callbackMap)})");
  }
}
