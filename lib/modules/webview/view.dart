import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/constants/cache.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:flutter_quick/utils/helper.dart';
import 'package:get/get.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'logic.dart';

class WebviewPage extends StatelessWidget {
  final logic = Get.put(WebviewLogic());
  final state = Get.find<WebviewLogic>().state;

  WebviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebviewLogic>(builder: (logic) {
      return Scaffold(
        appBar: state.title == null
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: true,
                centerTitle: true,
                elevation: 0.5,
                title: Text(
                  state.title!,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
        body: WebView(
          initialUrl: state.url ?? "http://8.134.38.88:3003/#/",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            state.controller = webViewController;
          },
          onPageFinished: (String url) async {
            print('Page finished loading: $url');
            state.title = await state.controller.getTitle();
            print("---->${state.title}");
            logic.update();
          },
          javascriptChannels: <JavascriptChannel>[
            _alertJavascriptChannel(context),
          ].toSet(),
        ),
      );
    });
  }

  void callH5(String callbackName, Map<String, dynamic> callbackMap) {
    logger("==== call h5 ==== \n "
        "callback: $callbackName, \n "
        "callbackMap: $callbackMap \n =============");
    state.controller
        .runJavascript("$callbackName(${json.encode(callbackMap)})");
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'FKSDKJsFramework',
        onMessageReceived: (JavascriptMessage message) async {
          var data = jsonDecode(message.message);
          var action = data["action"];
          print(data.toString() + "xxxxxxxxxxxxxxxx");
          print(action + " yyyyyyyyy");
          switch (action) {
            case "getLoginInfo":
              var token = SpUtil.getString(CacheConstants.token) ?? "";
              data['data'] = {"token": token};
              print(token + "5444444");
              Map<String, dynamic> callbackMap = data;

              callH5('webViewToLogin', callbackMap);
              break;
            case "toLogin":
              Get.toNamed(Routes.login)?.then((value) {
                var token = SpUtil.getString(CacheConstants.token);
                data['data'] = {"token": token};
                Map<String, dynamic> callbackMap = data;
                callH5('webViewToLogin', callbackMap);
              });
              break;
            case "getPackageName":
              var deviceData =
                  _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              deviceData["appVersion"] = packageInfo.version;
              String platformImei;
              try {
                platformImei = await ImeiPlugin.getImei(
                        shouldShowRequestPermissionRationale: false) ??
                    "";
              } on PlatformException {
                platformImei = '';
              }
              deviceData["imei"] = platformImei;
              data['data'] = deviceData;
              Map<String, dynamic> callbackMap = data;
              callH5('webViewGetPackageName', callbackMap);
              break;

            case "getVersionName":
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              data['data'] = {"versionName": packageInfo.version};

              Map<String, dynamic> callbackMap = data;

              callH5('webViewVersionName', callbackMap);
              break;
            case "logout":
              print("logout xxxxxxxxx");
              SpUtil.remove(CacheConstants.token);
              callH5('webViewLoginOut', {});
              Get.toNamed(Routes.login)?.then((value) {
                print("++++++++++");
                var token = SpUtil.getString(CacheConstants.token);
                data['data'] = {"token": token};
                data["callback"] = "webViewToLogin";
                Map<String, dynamic> callbackMap = data;
                callH5('webViewToLogin', callbackMap);
              });
              break;
            case "logEventByLocal":
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              data['data'] = {"versionName": packageInfo.version};
              Map<String, dynamic> callbackMap = data;
              callH5('logEventByLocal', callbackMap);
              break;

            case "timeSDK":
              if (!data["data"]["isSubmit"]) {
                return;
              }
              Get.find<WebviewLogic>().collectMessage(data);
              // var params = {
              //   "action": "timeSDK",
              //   "id": "0.6656999111432877",
              //   "data": {
              //     "orderNo": data["data"]["orderNo"].toString(),
              //     "userId": SpUtil.getString(CacheConstants.userId),
              //     "isSubmit": data["data"]["isSubmit"],
              //     "appList": false,
              //     "sms": false,
              //     "exif": false,
              //     "device": false,
              //     "contact": false,
              //     "location": false
              //   },
              //   "callback": "webViewToTime"
              // };
              // callH5("webViewToTime", params);
              break;
            default:
          }
        });
  }

  Map<String, String> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, String>{
      'appName': "SmartLoan",
      'afid': "0",
      'packageName': "com.mmt.smartloan",
      'androidId': build.androidId.toString(),
    };
  }
}
