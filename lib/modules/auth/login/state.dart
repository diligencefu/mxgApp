import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class LoginState {
  var controller1 = TextEditingController(text: "1234567893"); // 18161218432

  RxBool agree = false.obs;
  LoginState() {
    ///Initialize variables
  }
}
