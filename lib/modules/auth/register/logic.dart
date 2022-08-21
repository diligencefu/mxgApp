import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/repository/user_repository.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'state.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:install_referrer/install_referrer.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class RegisterLogic extends GetxController {
  final state = RegisterState();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void onReady() {
    super.onReady();
    timeStart();
  }

  timeStart() {
    state.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.seconds < 1) {
        timer.cancel();
        state.seconds = 60;
        state.btnText = "Conseguir";
        update();

        return;
      }
      state.seconds -= 1;
      state.btnText = "${state.seconds}s";
      update();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  sendSms() {
    var phone = Get.arguments["phone"];
    if (state.seconds != 60) return;

    UserRepository.sendSmsCode(phone).then((value) {
      if (value == null) {
        return;
      }
      state.seconds -= 1;
      state.btnText = "${state.seconds}s";
      update();
      timeStart();
    });
  }

  submit() async {
    // var result = await InstallReferrer.app;
    var mac = await PlatformDeviceId.getDeviceId;
    var deviceData =
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo, null);
    deviceData["mac"] = mac.toString();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    deviceData["appVersion"] = packageInfo.version;
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei = await ImeiPlugin.getImei(
              shouldShowRequestPermissionRationale: false) ??
          "";
    } on PlatformException {
      platformImei = '';
    }
    deviceData["imei"] = platformImei;

    var timezone = await FlutterNativeTimezone.getLocalTimezone();
    deviceData["timeZone"] = timezone;
    print(deviceData);
    UserRepository.login(deviceData).then((value) {
      if (value != null) {
        Get.offAllNamed(Routes.webview);
      }
    });
    // Get.toNamed(Routes.permission);
  }

  Map<String, String> _readAndroidBuildData(
      AndroidDeviceInfo build, dynamic result) {
    var phone = Get.arguments["phone"];
    var smsCode = state.controller1.text;
    if (smsCode.isEmpty) {
      return {};
    }

    return <String, String>{
      'mobile': phone,
      'verifyCode': smsCode,
      'adrVersion': build.version.sdkInt.toString(),
      'channelId': "SmartLoan",
      'appName': "SmartLoan",
      'packageName': "com.mmt.smartloan",
      'androidId': '',
      'releaseDate': build.version.securityPatch.toString(),
      'isRooted': "false",
      'timeZoneId': "",
      // "installReferce": referrerToReadableString(result.referrer),
      "installReferce": "",
      'verified': true.toString()
    };
  }

  String referrerToReadableString(InstallationAppReferrer referrer) {
    switch (referrer) {
      case InstallationAppReferrer.iosAppStore:
        return "Apple - App Store";
      case InstallationAppReferrer.iosTestFlight:
        return "Apple - Test Flight";
      case InstallationAppReferrer.iosDebug:
        return "Apple - Debug";
      case InstallationAppReferrer.androidGooglePlay:
        return "Android - Google Play";
      case InstallationAppReferrer.androidAmazonAppStore:
        return "Android - Amazon App Store";
      case InstallationAppReferrer.androidHuaweiAppGallery:
        return "Android - Huawei App Gallery";
      case InstallationAppReferrer.androidOppoAppMarket:
        return "Android - Oppo App Market";
      case InstallationAppReferrer.androidSamsungAppShop:
        return "Android - Samsung App Shop";
      case InstallationAppReferrer.androidVivoAppStore:
        return "Android - Vivo App Store";
      case InstallationAppReferrer.androidXiaomiAppStore:
        return "Android - Xiaomi App Store";
      case InstallationAppReferrer.androidManually:
        return "Android - Manual installation";
      case InstallationAppReferrer.androidDebug:
        return "Android - Debug";
    }
  }
}
