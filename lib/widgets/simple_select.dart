import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleSelect extends StatefulWidget {
  final List<String>? list;
  final ValueChanged<String>? onCheckUpdate;
  final String? defaultSelect;
  const SimpleSelect({
    Key? key,
    this.onCheckUpdate,
    this.list,
    this.defaultSelect,
  }) : super(key: key); //确定回调
  @override
  _SimpleSelectState createState() => _SimpleSelectState();
}

class _SimpleSelectState extends State<SimpleSelect> {
  late FixedExtentScrollController _controller;
  @override
  void initState() {
    super.initState();
    if (widget.defaultSelect != null) {
      _controller = FixedExtentScrollController(
          initialItem: widget.list!.indexOf(widget.defaultSelect!));
    } else {
      _controller = FixedExtentScrollController(initialItem: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
        height: 200.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "取消",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget
                        .onCheckUpdate!(widget.list![_controller.selectedItem]);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "确定",
                    style: TextStyle(
                      color: ColorConstants.appColor,
                      fontSize: 16.sp,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _controller,
                      useMagnifier: true,
                      magnification: 1,
                      itemExtent: 38,
                      onSelectedItemChanged: (index) {},
                      children: widget.list!
                          .asMap()
                          .map((key, value) {
                            return MapEntry(
                                key,
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: const Color(0xff333333),
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ));
                          })
                          .values
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
