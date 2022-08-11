import 'dart:math';

import 'package:flutter/material.dart';

/// 旋转+放大
class RotateScaleWidget extends StatefulWidget {
  final Widget child;
  final String? lottieUrl;
  const RotateScaleWidget({
    Key? key,
    required this.child,
    this.lottieUrl,
  }) : super(key: key);

  @override
  _RotateScaleWidgetState createState() => _RotateScaleWidgetState();
}

class _RotateScaleWidgetState extends State<RotateScaleWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleAnimationController;
  late Animation _animation;
  late Animation _scaleAnimation;

  @override
  void initState() {
    super.initState();

    /// 旋转动画
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat();
      }
    });

    /// 放大动画
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _scaleAnimationController.addListener(() {
      setState(() {});
    });
    _scaleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 放大结束时 停止旋转
        _animationController.reset();
      }
    });

    _animation = _animationController.drive(Tween(begin: 0.0, end: pi));
    _scaleAnimation =
        _scaleAnimationController.drive(Tween(begin: 0.0, end: 1.0));

    // 开始动画
    _animationController.forward();
    _scaleAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
