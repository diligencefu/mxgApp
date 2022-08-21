import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class LoginState {
  var controller1 = TextEditingController(text: "1234567895"); // 18161218432

  RxBool agree = true.obs;
  LoginState() {
    ///Initialize variables
  }
}
