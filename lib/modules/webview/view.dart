import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/constants/cache.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:flutter_quick/utils/helper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';
import 'package:liveness_plugin/liveness_plugin.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../logic.dart';
import 'logic.dart';

class WebviewPage extends StatelessWidget {
  final logic = Get.put(WebviewLogic());
  final state = Get.find<WebviewLogic>().state;

  WebviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebviewLogic>(builder: (logic) {
      return WillPopScope(
        onWillPop: () async {
          if (state.title != null) {
            Get.back();
            return true;
          }

          var webView = state.flutterWebViewPlugin;
          if (await webView.canGoBack()) {
            // WebHistory webHistory = await webView.getCopyBackForwardList();
            // if (webHistory.currentIndex <= 1) {
            //   return true;
            // }
            webView.goBack();
            return false;
          }
          exit(0);
          // return true;
        },
        child: Stack(
          children: [
            if (!state.isUpdate)
              Scaffold(
                body: WebviewScaffold(
                  url: state.url,
                  javascriptChannels: _alertJavascriptChannel(context),
                  mediaPlaybackRequiresUserGesture: false,
                  appBar: state.title == null
                      ? null
                      : AppBar(
                          backgroundColor: Colors.white,
                          automaticallyImplyLeading: true,
                          centerTitle: true,
                          elevation: 0.5,
                          toolbarHeight: 10,
                        ),
                  withZoom: true,
                ),
                // floatingActionButton: FloatingActionButton.extended(
                //   onPressed: () {
                //     // Add your onPressed code here!
                //   },
                //   label: const Text(''),
                //   icon: const Icon(Icons.thumb_up),
                //   backgroundColor: Colors.pink,
                // ),
              )
          ],
        ),
      );
    });
  }

  void callH5(String callbackName, Map<String, dynamic> callbackMap) {
    logger("==== call h5 ==== \n "
        "callback: $callbackName, \n "
        "callbackMap: $callbackMap \n =============");
    state.flutterWebViewPlugin
        .evalJavascript("$callbackName(${json.encode(callbackMap)})");
    logger("$callbackName(${json.encode(callbackMap)})");
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Set<JavascriptChannel> _alertJavascriptChannel(BuildContext contextx) {
    return [
      JavascriptChannel(
          name: 'FKSDKJsFramework',
          onMessageReceived: (JavascriptMessage message) async {
            // logger(message.message.runtimeType);
            // logger(message.message);
            var data = jsonDecode(message.message);
            var action = data["action"];
            Get.log(">>>>>>>>${message.message}---${action}");
            // Get.log(">>>>>>>>${action}");

            switch (action) {
              case "getLoginInfo":
                var token = SpUtil.getString(CacheConstants.token) ?? "";
                if (token.isEmpty) {
                  logic.toLoginPage(data);
                  return;
                }
                data['data'] = {"token": token};
                data["result"] = "ok";
                Map<String, dynamic> callbackMap = data;
                callH5('webViewToLogin', callbackMap);
                break;
              case "toLogin":
                logic.toLoginPage(data);
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
                data["result"] = "ok";
                Map<String, dynamic> callbackMap = data;
                callH5('webViewGetPackageName', callbackMap);
                break;

              case "getVersionName":
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                data['data'] = {"versionName": packageInfo.version};
                data["result"] = "ok";
                Map<String, dynamic> callbackMap = data;
                callH5('webViewVersionName', callbackMap);
                break;
              case "logout":
                SpUtil.remove(CacheConstants.token);
                callH5('webViewLoginOut', {});
                logic.toLoginPage(data);
                break;
              case "logEventByLocal":
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                data['data'] = {"versionName": packageInfo.version};
                Map<String, dynamic> callbackMap = data;
                break;
              case "logEventByAF":
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                data['data'] = {"versionName": packageInfo.version};
                Map<String, dynamic> callbackMap = data;
                break;

              case "timeSDK":
                // if (!data["data"]["isSubmit"]) {
                //   return;
                // }
                Get.find<WebviewLogic>().collectMessage(data);
                break;

              case "getAccuauthSDK":
                logic.callLivenessDetection(data);
                break;
              case "setNewToken":
                SpUtil.putString(CacheConstants.token, data["token"]);
                data["callback"] = "setNewToken";
                Map<String, dynamic> callbackMap = data;
                callH5('setNewToken', callbackMap);
                break;
              case "selectContact":
                final PhoneContact contact =
                    await FlutterContactPicker.pickPhoneContact();
                data["data"]["name"] = contact.fullName;
                data["data"]["phone"] = contact.phoneNumber?.number;
                data["result"] = "ok";
                Map<String, dynamic> callbackMap = data;
                callH5('getWebViewSelectContact', callbackMap);
                break;
              case 'ToWhatsapp':
                break;
              case 'toGooglePlayer':
                if (data["downloadLink"].toString().isNotEmpty) {
                  launch(data["downloadLink"]);
                }
                break;
              default:
            }
          })
    ].toSet();
  }

  Map<String, String> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, String>{
      'appName': "SmartLoan",
      'afid': Get.find<AppLogic>().uid,
      'packageName': "com.mmt.smartloan",
      'androidId': Get.find<AppLogic>().androidId,
    };
  }
}
