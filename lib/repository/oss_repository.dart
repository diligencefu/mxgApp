import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quick/http/dio_api.dart';

import '../utils/helper.dart';

// 图片上传 : 图片上传API
class OssRepository {
  /// 上传
  static Future upload(FormData formData) async {
    var resp = await DioApi.getInstance().post(
      '/lsfb-ums/file/upload/artificer',
      data: formData,
    );
    EasyLoading.dismiss();
    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 更新技师头像
  static Future artificerAvatarUpload(String avatar) async {
    var resp = await DioApi.getInstance().post(
      '/lsfb-artificer/artificer/lsfbArtificer/artificerAvatarUpload',
      queryParameters: {
        "avatar": avatar,
      },
    );
    EasyLoading.dismiss();
    if (resp.sucess) {
      app().updateUser();
      return resp.data;
    }
    toast(resp.message);

    return null;
  }
}
