import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewState {
  String? title;
  String url = "http://8.134.38.88:3003/#/";
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  bool isUpdate = false;

  WebviewState() {
    ///Initialize variables
  }
}
