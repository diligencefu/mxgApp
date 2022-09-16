import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quick/repository/user_repository.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:flutter_quick/utils/helper.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../logic.dart';
import 'state.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:install_referrer/install_referrer.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:sp_util/sp_util.dart';
import 'package:flutter_quick/constants/cache.dart';

class RegisterLogic extends GetxController {
  final state = RegisterState();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void onReady() {
    super.onReady();
    timeStart();
  }

  timeStart() {
    state.btnText = "${state.seconds}s";
    update();

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
    var phone = Get.arguments["mobile"];
    if (state.seconds != 60) return;
    // EasyLoading.show();
    Get.find<AppLogic>().logEvent("logincode_verificationResend");
    UserRepository.sendSmsCode(phone, Get.arguments["existed"] ? "1" : "2")
        .then((value) {
      EasyLoading.dismiss();
      if (value == null) {
        Get.find<AppLogic>().logEvent("logincode_SMSFailed");
        return;
      }
      state.seconds -= 1;
      state.btnText = "${state.seconds}s";
      update();
      timeStart();
    });
  }

  submit() async {
    Get.find<AppLogic>().logEvent("logincode_confirm");

    var smsCode = state.controller1.text;
    if (smsCode.isEmpty) {
      toast("Código de verificación vacío");
      return;
    }
    if (smsCode.length != 6) {
      toast("Codigo de verificacion inválido, envia nuevamente");
      return;
    }
    var deviceData =
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo, null);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    deviceData["appVersion"] = packageInfo.version;
    // EasyLoading.show();
    if (Get.arguments["existed"] == false) {
      // Get.find<AppLogic>().logEvent("logincode_reg");
      UserRepository.register(deviceData).then((value) {
        EasyLoading.dismiss();
        if (value != null) {
          // Get.find<AppLogic>().logEvent("logincode_RegSuccess");
          SpUtil.putString(CacheConstants.token, value["token"]);
          SpUtil.putString(CacheConstants.userId, value["userId"]);
          SpUtil.putString(CacheConstants.mobile, Get.arguments["mobile"]);
          Get.offAllNamed(Routes.webview);
        } else {
          // Get.find<AppLogic>().logEvent("logincode_Regfailed");
        }
      });
      return;
    }
    logger(deviceData);
    // Get.find<AppLogic>().logEvent("logincode_login");
    UserRepository.login(deviceData).then((value) {
      EasyLoading.dismiss();
      if (value != null) {
        // Get.find<AppLogic>().logEvent("logincode_LoginSuccess");
        Get.offAllNamed(Routes.webview);
      } else {
        // Get.find<AppLogic>().logEvent("logincode_Loginfailed");
      }
    });
  }

  Map<String, String> _readAndroidBuildData(
      AndroidDeviceInfo build, dynamic result) {
    var phone = Get.arguments["mobile"];
    var smsCode = state.controller1.text;
    if (smsCode.isEmpty) {
      return {};
    }

    return <String, String>{
      'mobile': phone,
      'verifyCode': smsCode,
      'adrVersion': build.version.sdkInt.toString(),
      'channelId': "SmartLoan",
      'packageName': "com.mmt.smartloan",
      'androidId': Get.find<AppLogic>().androidId,
      // "installReferce": referrerToReadableString(result.referrer),
      "installReferce": "",
      'appName': "SmartLoan",
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
