import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick/routes/routes.dart';
import 'package:flutter_quick/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../logic.dart';

class PolicyWidget extends StatefulWidget {
  final Function(bool)? onChecked;

  const PolicyWidget({
    Key? key,
    this.onChecked,
  }) : super(key: key);

  @override
  _PolicyWidgetState createState() => _PolicyWidgetState();
}

class _PolicyWidgetState extends State<PolicyWidget> {
  bool _checked = true;

  void _onChecked() {
    setState(() {
      _checked = !_checked;
    });

    if (widget.onChecked != null) {
      widget.onChecked!(_checked);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style1 = TextStyle(
      fontSize: 16.sp,
      color: const Color(0xff4D3633),
    );

    final style2 = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xff000000),
    );
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: _onChecked,
              child: Container(
                margin: EdgeInsets.only(right: 0.w),
                child: Image.asset(
                  "assets/images/${!_checked ? 'nochoose' : 'choose'}.png",
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ),
          ),
          TextSpan(
            text: "AI continuar,acepta nuestros",
            style: style1,
          ),
          TextSpan(
            text: "<Terminos de Servicin>",
            style: style2,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.find<AppLogic>().logEvent("loginPhone_termOfService");
                Get.toNamed(
                  Routes.webview,
                  arguments: {
                    "url": "http://8.134.38.88:3003/#/termsCondition",
                    "title": "Política De Privacidad",
                  },
                );
              },
          ),
          TextSpan(
            text: ", ",
            style: style1,
          ),
          TextSpan(
            text: "<Politica de privacidad>",
            style: style2,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.find<AppLogic>().logEvent("loginPhone_privacy");
                Get.toNamed(
                  Routes.webview,
                  arguments: {
                    "url": "http://8.134.38.88:3003/#/provicy",
                    "title": "Términos de Uso",
                  },
                );
              },
          ),
          TextSpan(
            text: "﹥y recibe avisos por SMS y correo electronico.",
            style: style1,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
