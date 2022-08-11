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
import '../../../routes/routes.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final state = LoginState();

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
    var phone = state.controller1.text;
    if (phone.isEmpty) {
      toast("请输入手机号");
      return;
    }
    UserRepository.checkPhone(phone).then((value) {
      if (value == null) {
        return;
      }
      UserRepository.sendSmsCode(phone).then((value) {
        Get.toNamed(Routes.register, arguments: {"phone": phone});
      });
    });
  }
}
