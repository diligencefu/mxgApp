import 'package:flutter_quick/logic.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(AppLogic(), permanent: true);
  }
}
