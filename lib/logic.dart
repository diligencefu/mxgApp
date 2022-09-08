// ignore_for_file: nullable_type_in_catch_clause

import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_proxy_plugin/dio_proxy_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/modules/webview/logic.dart';
import 'package:flutter_quick/repository/user_repository.dart';
import 'package:flutter_quick/state.dart';
import 'package:flutter_quick/utils/helper.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';

import 'constants/cache.dart';
import 'models/user_model.dart';
import 'routes/routes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 全局逻辑 用于获取用户状态、主题设置等信息
class AppLogic extends GetxController {
  final state = AppState();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late AppsflyerSdk _appsflyerSdk;

  String? androidId = "";
  String? version = "";

  @override
  onInit() async {
    super.onInit();

    /// 从缓存设置用户信息
    var userCache = SpUtil.getObject(CacheConstants.user);
    if (userCache != null) {
      state.user = UserModel.fromJson(userCache as Map<String, dynamic>);

      update();
    }
    // updateUser();
    uploadDeviceInfo();
    // _setProxy();
    initConnectivity();
    initAppsFlyer();
    addPermissionObserver();
    logEvent("splash_open");
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  initAppsFlyer() {
    Map<String, Object> appsFlyerOptions = {
      "afDevKey": "yFbZbrMQ7eoqbZ4BdAPN",
      // "afAppId": "appId",
      "isDebug": true
    };
    _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
  }

  /// 更新用户信息
  Future updateUser() async {
    // var data = await UserRepository.userInfo();
    // if (data != null) {
    //   SpUtil.putObject(CacheConstants.user, data.toJson());
    //   state.user = data;
    // }

    // update();
  }

  /// 退出
  logout() async {
    Get.offAllNamed(Routes.login);
    SpUtil.clear();
  }

  uploadDeviceInfo() async {
    // if (SpUtil.getString(CacheConstants.isUploadedDeviceInfo) == "true") {
    //   return;
    // }

    var deviceData =
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo, null);
    var packageInfo = await PackageInfo.fromPlatform();

    deviceData["appVersion"] = packageInfo.version;
    UserRepository.uplaodDeviceInfo(deviceData).then((value) {
      if (value == null) {
        return;
      }
      SpUtil.putString(CacheConstants.isUploadedDeviceInfo, "true");
    });
  }

  Map<String, String> _readAndroidBuildData(
      AndroidDeviceInfo build, dynamic result) {
    androidId = build.androidId;
    return <String, String>{
      'adrVersion': build.version.sdkInt.toString(),
      'channelId': "SmartLoan",
      'appName': "SmartLoan",
      'installReferce': "",
      'afId': "",
      'packageName': "com.mmt.smartloan",
      'androidId': build.androidId ?? "",
    };
  }

  Future<void> _setProxy() async {
    String deviceProxy = '';
    var dio = Dio()..options.baseUrl = 'https://httpbin.org/';

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      Get.put(WebviewLogic()).toLoginPage({
        "action": "getLoginInfo",
        "id": "0.40636546644814286",
        "data": {"token": ""},
        "callback": "webViewToLogin"
      });
    }
  }

  // Future<bool?>
  logEvent(String eventName) {
    // var eventValues = {
    //   'packageName': "com.mmt.smartloan",
    //   "androidId": androidId ?? "",
    //   "installRefer": "",
    //   "appVersion": version,
    // };
    // return _appsflyerSdk.logEvent(eventName, eventValues);
  }

  addPermissionObserver() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      logger("messagemessagemessagemessage");
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      logger("messagemessagemessagemessage");
      // The OS restricts access, for example because of parental controls.
    }
  }
}
