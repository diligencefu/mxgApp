import 'package:flutter/material.dart';

class LoadingErrorWidget extends StatefulWidget {
  final VoidCallback? errorRetry; //无数据事件处理
  final String? message;

  const LoadingErrorWidget({Key? key, this.errorRetry, this.message})
      : super(key: key);

  @override
  _LoadingErrorWidgetState createState() {
    return _LoadingErrorWidgetState();
  }
}

class _LoadingErrorWidgetState extends State<LoadingErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: InkWell(
        onTap: widget.errorRetry,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             const SizedBox(
              width: 405,
              height: 100,
              // child: Image.asset('images/icon_work.png'),
            ),
            Text(
              widget.message ?? "Loading Error!",
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
