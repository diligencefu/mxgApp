import 'dart:async';

import 'package:get/get.dart';
import '../../routes/routes.dart';
import 'state.dart';

class SplashLogic extends GetxController {
  final state = SplashState();

  void onSwiperChange(int index) {
    update();
  }

  @override
  void onReady() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      timer.cancel();
      // Get.offAllNamed(Routes.main);
    });
  }
}
