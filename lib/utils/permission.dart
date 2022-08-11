import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /**
   * 所有
   */
  static Future requestAllPermission() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.speech,
      Permission.storage,
      Permission.location,
      Permission.phone,
      Permission.notification,
    ].request();

    if (await Permission.camera.isGranted) {
      print("相机权限申请通过");
    } else {
      print("相机权限申请失败");
    }

    if (await Permission.photos.isGranted) {
      print("照片权限申请通过");
    } else {
      print("照片权限申请失败");
    }

    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
    } else {
      print("语音权限申请失败");
    }

    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }

    if (await Permission.location.isGranted) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请失败");
    }

    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
    } else {
      print("手机权限申请失败");
    }

    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
    } else {
      print("通知权限申请失败");
    }
  }

  static Future<bool> requestCameraPermission() async {
    await [
      Permission.camera,
    ].request();

    if (await Permission.camera.isGranted) {
      print("相机权限申请通过");
      return true;
    } else {
      print("相机权限申请失败");
      return false;
    }
  }

  static Future<bool> requestPhotosPermission() async {
    await [
      Permission.photos,
    ].request();

    if (await Permission.photos.isGranted) {
      print("照片权限申请通过");
      return true;
    } else {
      print("照片权限申请失败");
      return false;
    }
  }

  static Future requestSpeechPermission() async {
    await [
      Permission.speech,
    ].request();

    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
    } else {
      print("语音权限申请失败");
    }
  }

  static Future requestStoragePermission() async {
    await [
      Permission.storage,
    ].request();

    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }
  }

  static Future requestLocationPermission() async {
    await [
      Permission.location,
    ].request();

    if (await Permission.location.isGranted) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请失败");
    }
  }

  static Future requestPhonePermission() async {
    await [
      Permission.phone,
    ].request();

    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
    } else {
      print("手机权限申请失败");
    }
  }

  static Future requestNotificationPermission() async {
    await [
      Permission.notification,
    ].request();

    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
    } else {
      print("通知权限申请失败");
    }
  }
}
