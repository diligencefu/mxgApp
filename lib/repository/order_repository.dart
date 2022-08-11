import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quick/http/dio_api.dart';

import '../utils/helper.dart';

class OrderRepository {
  static Future pageOrder(int status, int current) async {
    var resp = await DioApi.getInstance().post(
      "/lsfb-artificer/artificer/order/PageOrder",
      data: {
        "condition": {"status": status},
        "current": current,
        "size": 10
      },
    );
    if (resp.sucess) {
      return resp.data["records"];
    }
    toast(resp.message);

    return null;
  }

  /// 订单详情
  static Future orderDetail(dynamic orderId) async {
    var resp = await DioApi.getInstance().post(
      "/lsfb-artificer/artificer/order/getOrderDetailsById",
      queryParameters: {"orderId": orderId},
    );
    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 加钟费用列表
  static Future clockUpAmountList(dynamic orderId) async {
    var resp = await DioApi.getInstance().post(
        "/lsfb-artificer/artificer/order/clockUpAmountList",
        queryParameters: {"orderId": orderId});

    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 服务加钟收费(返回加钟订单号)
  static Future addBellCharge(dynamic params) async {
    var resp = await DioApi.getInstance().post(
        "/lsfb-artificer/artificer/order/addBellCharge",
        queryParameters: params);

    EasyLoading.dismiss();
    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 服务加钟收费(返回加钟订单号)
  static Future receiptQrCode(dynamic addBellOrderNo) async {
    var resp = await DioApi.getInstance().post(
        "/lsfb-artificer/artificer/order/receiptQrCode",
        queryParameters: {"addBellOrderNo": addBellOrderNo});

    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }

  /// 查询支付结果
  static Future orderPoll(dynamic addBellOrderNo) async {
    var resp = await DioApi.getInstance().post(
        "/lsfb-artificer/artificer/order/orderPoll",
        queryParameters: {"orderNo": addBellOrderNo});

    if (resp.sucess) {
      return resp.data;
    }
    toast(resp.message);

    return null;
  }
}
