import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quick/config/config.dart';
import 'package:flutter_quick/repository/user_repository.dart';
import 'package:flutter_quick/utils/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

import '../../../constants/cache.dart';
import '../../../logic.dart';
import '../../../routes/routes.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final state = LoginState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Get.put(AppLogic()).logEvent("loginPhone_open");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  sendSms() {
    var phone = state.controller1.text;
    if (phone.isEmpty) {
      toast("请输入手机号");
      return;
    }
  }

  submit() {
    Get.find<AppLogic>().logEvent("loginPhone_next");
    var phone = state.controller1.text;
    if (phone.isEmpty) {
      toast("请输入手机号");
      return;
    }
    if (phone.length > 10) {
      return;
    }
    EasyLoading.show();
    UserRepository.checkPhone(phone).then((value1) {
      logger(value1);
      if (value1 == null) {
        EasyLoading.dismiss();
        return;
      }
      Get.find<AppLogic>().logEvent("loginPhone_sendOtp");
      UserRepository.sendSmsCode(phone, value1["existed"] ? "1" : "2")
          .then((value) {
        EasyLoading.dismiss();
        if (value == null) {
          return;
        }
        Get.toNamed(Routes.register, arguments: value1);
      });
    });
  }
}
