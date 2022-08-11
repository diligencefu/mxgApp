import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quick/enums/page_status.dart';
import 'package:flutter_quick/events.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../utils/helper.dart';
import 'loading/loading_empty_widget.dart';
import 'loading/loading_error_widget.dart';

///
/// 下拉刷新 上拉加载统用页面
///

class RefreshWidget extends StatelessWidget {
  final RefreshListMixin? controller;
  final Widget? child;

  const RefreshWidget({Key? key, this.controller, this.child})
      : super(key: key);

  /// 加载中
  Widget _buildLoading() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  /// 加载异常
  Widget _buildError() {
    return const LoadingErrorWidget();
  }

  /// 数据为空
  Widget _buildEmpty() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          const LoadingEmptyWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(controller != null, "RefreshWidget中的controller参数必传");
    if (controller!.showLoading && controller!.status == PageStatus.loading) {
      return _buildLoading();
    }
    if (controller!.status == PageStatus.error) {
      return _buildError();
    }
    if (controller!.status == PageStatus.none) {
      return _buildEmpty();
    }
    return SmartRefresher(
      controller: controller!.refreshController,
      onRefresh: controller!.refreshData,
      onLoading: controller!.loadMoreData,
      enablePullUp: controller!.enablePullUp,
      enablePullDown: controller!.enablePullDown,
      child: child ??
          Center(
            child: Text(controller.toString()),
          ),
    );
  }
}

/// 适用于只有一个列表但是没分页的页面
mixin RefreshListMixin<T> {
  /// 页面状态
  var status = PageStatus.loading;

  /// 是否显示加载中
  var showLoading = false;

  /// 开启上拉加载
  var enablePullUp = true;

  /// 开启下拉刷新
  var enablePullDown = true;

  /// 刷新控制器
  var refreshController = RefreshController(initialRefresh: false);

  /// 分页第一页页码
  int currentPage = 1;

  /// 分页条目数量
  int pageSize = 10;

  /// 页面数据
  List<T> list = [];

  /// 加载list数据 分页加载是只用实现这个
  Future initData({int currentPage = 1});

  /// data回调
  onCompleted(List<T> data) {}

  /// 刷新
  refreshData({bool init = false}) {
    try {
      if (showLoading) {
        EasyLoading.show(status: 'loading...');
      }
      currentPage = 1;
      initData().then((event) {
        List<T> data = event;
        if (data.isEmpty) {
          list.clear();
          status = PageStatus.none;
        } else {
          /// data回调
          onCompleted(data);

          /// 因为没分页 每次刷新都重置list
          list = data;
          status = PageStatus.success;
        }
        eventBus.fire(UpdateEvent());

        EasyLoading.dismiss();
        refreshController.refreshCompleted(
            resetFooterState: data.length >= pageSize);
      });
    } catch (e) {
      logger("refresh error", level: Level.error);
      logger(e, level: Level.error);
      status = PageStatus.error;
      refreshController.refreshFailed();
      EasyLoading.dismiss();
    }
  }

  /// 加载更多
  loadMoreData() {
    try {
      initData(currentPage: ++currentPage).then((event) {
        List<T> data = event;

        if (data.isEmpty) {
          currentPage--;
          refreshController.loadNoData();
        } else {
          onCompleted(data);
          list.addAll(data);
          if (data.length < pageSize) {
            refreshController.loadNoData();
          } else {
            refreshController.loadComplete();
          }
        }
        eventBus.fire(UpdateEvent());
      });
    } catch (e) {
      currentPage--;
      refreshController.loadFailed();
    }
  }
}
