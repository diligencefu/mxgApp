import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';
import '../../constants/cache.dart';
import '../../logic.dart';
import '../../repository/user_repository.dart';
import '../../utils/helper.dart';
import '../dialog.dart';
import 'state.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:liveness_plugin/liveness_plugin.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ota_update/ota_update.dart';

class WebviewLogic extends GetxController with LivenessDetectionCallback {
  final WebviewState state = WebviewState();
  static const channel = MethodChannel("timesdk_plugin");
  dynamic data;
  UpdateDialog? dialog;

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
    addObserver();
    if (state.url == "http://8.134.38.88:3003/#/") {
      checkUpdate();
    }
  }

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
    String base64Image = resultMap["base64Image"];

    Uint8List bytes = base64.decode(base64Image);

    compressList(bytes, data, resultMap);
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
      "result": "ok",
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
      "callback": data["webViewToTime"]
    };
    channel.invokeMethod('collectMessage', json.encode(param));
  }

  /// 图片压缩 File -> Uint8List
  void compressList(Uint8List bytes, dynamic data, Map resultMap) async {
    var params = data;
    var result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 256,
      minHeight: 256,
      quality: 30,
      rotate: 90,
    );
    params["data"]["livenessId"] = resultMap["livenessId"];
    params["data"]["transactionId"] = resultMap["transactionId"];
    params["data"]["file"] = uint8ListTob64(result);
    params["result"] = "ok";
    Map<String, dynamic> callbackMap = params;
    callH5("webViewFaceImg", callbackMap);
  }

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    // String header = "data:image/png;base64,";
    // return header + base64String;
    return base64String;
  }

  toLoginPage(dynamic data) {
    Get.offAllNamed(Routes.login)?.then((value) {
      var token = SpUtil.getString(CacheConstants.token);
      data['data'] = {"token": token};
      data["callback"] = "webViewToLogin";
      Map<String, dynamic> callbackMap = data;
      callH5('webViewToLogin', callbackMap);
    });
  }

  addObserver() {
    state.flutterWebViewPlugin.onHttpError.listen((event) {
      toLoginPage({
        "action": "getLoginInfo",
        "id": "0.40636546644814286",
        "data": {"token": ""},
        "callback": "webViewToLogin"
      });
    });
    state.flutterWebViewPlugin.onStateChanged.listen((event) {
      logger(event);
    });

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

  checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var old = packageInfo.version;

    UserRepository.checkUpdate({"packageName": "com.mmt.smartloan"})
        .then((value) {
      if (value == null) {
        return;
      }
      if (!value["link"].toString().endsWith(".apk")) {
        // toast("apk地址错误");
        // return;
      }

      if (haveNewVersion(value["versionName"], old)) {
        customStyle(value);
      }

      // update();
    });
  }

  void customStyle(dynamic value) {
    state.isUpdate = true;
    update();
    if (dialog != null && dialog!.isShowing()) {
      return;
    }

    dialog = UpdateDialog.showUpdate(Get.context!,
        title: ' Nueva versión disponible',
        updateContent: 'Por favor, actualice a la última versión\n',
        titleTextSize: 18,
        contentTextSize: 16,
        buttonTextSize: 18,
        topImage: Image.asset('assets/images/update_icon.png'),
        extraHeight: 20,
        radius: 8,
        themeColor: const Color(0xff0AB27D),
        width: 320.w,
        isForce: value["forcedUpdate"],
        updateButtonText: 'Confirmar ', onUpdate: () {
      state.isUpdate = false;
      update();
      OtaUpdate().execute(value["link"]);
      Get.find<AppLogic>().logEvent("updateConfirm_yes");
    }, onIgnore: () {
      Get.find<AppLogic>().logEvent("updateConfirm_no");
      state.isUpdate = false;
      update();
    });
  }

  bool haveNewVersion(String newVersion, String old) {
    if (newVersion.isEmpty || old.isEmpty) return false;
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.length == 0 || oldList.length == 0) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        return true;
      } else if (newVersionInt < oldVersion) {
        return false;
      }
    }
    return false;
  }
}
