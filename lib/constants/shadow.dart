import 'package:flutter/material.dart';

class ShadowConstant {
  static BoxShadow boxShadow = BoxShadow(
    color: const Color(0xff000000).withOpacity(.05),
    offset: const Offset(0.0, 0.0), //阴影y轴偏移量
    blurRadius: 10, //阴影模糊程度
    spreadRadius: 2, //阴影扩散程度
  );
}
