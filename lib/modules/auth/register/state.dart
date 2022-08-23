import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class RegisterState {
  var controller1 = TextEditingController(text: ""); // 18161218432

  RxBool agree = false.obs;

  Timer? timer;
  int seconds = 60;
  String btnText = "Conseguir";

  RegisterState() {
    ///Initialize variables
  }
}
