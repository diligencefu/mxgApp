import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///空数据时的界面
class LoadingEmptyWidget extends StatefulWidget {
  final VoidCallback? emptyRetry; //无数据事件处理

  const LoadingEmptyWidget({Key? key, this.emptyRetry}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingEmptyWidgetState();
  }
}

class _LoadingEmptyWidgetState extends State<LoadingEmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200.w,
          child: Image.asset(
            'assets/images/no_data.png',
            width: 200.w,
            fit: BoxFit.fitWidth,
          ),
        ),
        SizedBox(height: 15),
        Text(
          '暂无数据',
          style: TextStyle(color: Color(0xff9a9a9a), fontSize: 14.0),
        )
      ],
    );
  }
}
