import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick/logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

/// 日志
///
///
logger(dynamic message, {Level level = Level.debug}) {
  var logger = Logger();
  logger.log(level, message);
}

/// showToast二次封装
///
///
toast(dynamic message, {Duration? duration}) {
  BotToast.showText(
    text: message,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 15.sp,
    ),
    align: Alignment(0, 0.1),
  );
}

String formatTime(int time) {
  if (time < 10) {
    return "0$time";
  } else {
    return "$time";
  }
}

Future<bool> requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  statuses[Permission.storage].toString();
  if (statuses[Permission.storage] == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
}

/// 十六进制颜色，
Color hexToColor(String hex, {double opacity = 1}) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  ).withOpacity(opacity);
}

/// 取随机颜色
///
///
Color randomColor() {
  var red = Random.secure().nextInt(255);
  var greed = Random.secure().nextInt(255);
  var blue = Random.secure().nextInt(255);
  return Color.fromARGB(255, red, greed, blue);
}

AppLogic app() {
  AppLogic logic = Get.find();
  return logic;
}
