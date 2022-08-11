## 开发环境

```
Flutter 2.10.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 7e9793dee1 (5 weeks ago) • 2022-03-02 11:23:12 -0600
Engine • revision bd539267b4
Tools • Dart 2.16.1 • DevTools 2.9.2
```
## 路由和状态管理基于getx

<https://juejin.cn/post/6924104248275763208>


<https://github.com/KevinZhang19870314/flutter_getx_boilerplate>


```dart
  @override
  onInit() {
    super.onInit();

    /// 每次更改都会回调
    ever(count1, (_) => print("$_ has been changed"));

    /// 第一次更改回调
    once(count1, (_) => print("$_ was changed once"));

    /// 更改后3秒回调
    debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 3));

    ///3秒内更新回调一次
    interval(count1, (_) => print("interval $_"), time: Duration(seconds: 3));
  }
```

