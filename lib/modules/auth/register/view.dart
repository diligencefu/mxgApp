import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/constants/colors.dart';
import 'package:flutter_quick/modules/auth/policy_widget.dart';
import 'package:flutter_quick/widgets/buttons/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class RegisterPage extends StatelessWidget {
  final RegisterLogic logic = Get.put(RegisterLogic());
  final RegisterState state = Get.find<RegisterLogic>().state;

  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterLogic>(
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: layoutSubviews(logic),
        );
      },
    );
  }

  Widget layoutSubviews(RegisterLogic logic) {
    return Stack(children: [
      Container(
          width: 1.sw,
          height: 1.sh,
          child: Image(
            image: AssetImage("assets/images/login_back_image.png"),
            fit: BoxFit.fill,
          )),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 50),
            child: Image(
              image: AssetImage("assets/images/login_head_icon.png"),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Privacidad y Seguridad  \nConfianza de 1 millón de usuarios",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 30.w),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 12, right: 12),
              padding: EdgeInsets.only(top: 20, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: state.controller1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                          ),
                          cursorColor: Colors.black,
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6) //限制长度
                          ],
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 15.w, bottom: 15.w),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorConstants.borderColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorConstants.borderColor,
                                  width: 1,
                                ),
                              ),
                              hintText: 'numero de telefono',
                              hintStyle: TextStyle(
                                color: const Color(0xff898989),
                                fontSize: 17.sp,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  logic.sendSms();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 15, left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    state.btnText,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(height: 22.w),
                        AppButton(
                          title: "Siguiente",
                          bgColor: Color.fromARGB(255, 110, 215, 170),
                          onTap: logic.submit,
                        ),
                      ],
                    ),
                  ),
                  PolicyWidget(
                    onChecked: (e) {
                      state.agree.value = e;
                    },
                  ),
                  SizedBox(height: 22.w),
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
