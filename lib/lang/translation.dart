import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cn.dart';
import 'en.dart';

class Translation extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': cnTranslation,
        'en': enTranslation,
      };
}
