import 'dart:io';

import 'package:flutter_quick/utils/helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtils {
  /// 高德地图调用
  static Future<bool> openAmap(
    double longitude,
    double latitude, {
    String address = "",
    bool showErr: true,
  }) async {
    try {
      String url =
          '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2&poiname=${address}';
      if (Platform.isIOS) url = Uri.encodeFull(url);

      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        if (showErr) toast('无法调起高德地图');
      }
    } on Exception catch (_) {
      if (showErr) toast('无法调起高德地图');
      return false;
    }
    return true;
  }

  /// 百度地图
  static Future<bool> openBaiduMap(
    double longitude,
    double latitude, {
    bool showErr: true,
  }) async {
    try {
      var url =
          'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving';

      if (Platform.isIOS) url = Uri.encodeFull(url);
      if (await canLaunchUrlString(url)) {
        logger(url.toString());

        await launchUrlString(url);
      } else {
        if (showErr) toast('无法调起百度地图');
      }
    } on Exception catch (_) {
      if (showErr) toast('无法调起百度地图');
      return false;
    }
    return true;
  }
}
