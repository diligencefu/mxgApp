
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimateImage extends StatefulWidget {
  final String imageUrl;
  final bool isFile;

  const AnimateImage({Key? key, required this.imageUrl, required this.isFile})
      : super(key: key);
  @override
  _AnimateImageState createState() {
    return _AnimateImageState();
  }
}

class _AnimateImageState extends State<AnimateImage>
    with SingleTickerProviderStateMixin {
  ImageInfo? _imageInfo;
  late AnimationController controller;
  late Animation<double> animation;

  double offset = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    controller.dispose(); // 资源释放
    super.dispose();
  }

  //// 初始化动画以及图片
  _init() async {
    controller = AnimationController(
      duration: const Duration(milliseconds: 15000), //时长
      vsync: this,
    );

    var tween = Tween(begin: 0.0, end: -30.0); //创建从25到150变化的Animatable对象
    animation = tween.animate(controller); //执行animate方法，生成
    animation.addListener(() {
      if (mounted) {
        setState(() {
          offset = animation.value;
        });
      }
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            controller.reverse();
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            controller.forward();
          }
        });
      }
    });
    _imageInfo = await getImageInfo(widget.imageUrl, Get.context!);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        controller.forward();
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<ImageInfo> getImageInfo(
    String url,
    BuildContext context,
  ) async {
    /// 本地图
    if (widget.isFile) {
      FileImage assetImage = FileImage(File(url));
      ImageStream stream =
          assetImage.resolve(createLocalImageConfiguration(context));
      Completer<ImageInfo> completer = Completer();
      stream.addListener(ImageStreamListener((imageInfo, __) {
        return completer.complete(imageInfo);
      }));
      return completer.future;
    }

    /// 网络图
    NetworkImage assetImage = NetworkImage(url);
    ImageStream stream =
        assetImage.resolve(createLocalImageConfiguration(context));
    Completer<ImageInfo> completer = Completer();
    stream.addListener(ImageStreamListener((imageInfo, __) {
      return completer.complete(imageInfo);
    }));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _imageInfo != null
          ? CustomPaint(
              painter: _PosterPainter(_imageInfo!, offset),
              child: Container(),
            )
          : Container(),
    );
  }
}

class _PosterPainter extends CustomPainter {
  ImageInfo imageInfo;

  double offset;
  _PosterPainter(this.imageInfo, this.offset);

  @override
  paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.blueGrey);

    canvas.restore();
    canvas.save();

    canvas.drawImageRect(
      imageInfo.image,
      Rect.fromLTWH(
        0,
        0,
        imageInfo.image.width.toDouble(),
        imageInfo.image.width.toDouble() * (size.height / size.width),
      ),
      Rect.fromLTWH(
        offset,
        offset,
        size.width * 1.2,
        size.height * 1.2,
        // (imageInfo.image.height.toDouble()) * 1.3 / rate,
      ),
      Paint(),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
