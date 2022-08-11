import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/constants/colors.dart';
import 'package:flutter_quick/modules/auth/policy_widget.dart';
import 'package:flutter_quick/modules/dialog.dart';
import 'package:flutter_quick/widgets/buttons/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class MaxPage extends StatelessWidget {
  final MaxLogic logic = Get.put(MaxLogic());
  final MaxState state = Get.find<MaxLogic>().state;

  MaxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaxLogic>(
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: layoutSubviews(logic),
        );
      },
    );
  }

  UpdateDialog? dialog;

  Widget layoutSubviews(MaxLogic logic) {
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
          SizedBox(height: 70.w),
          Center(
            child: Text(
              "Max",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
              ),
            ),
          ),
          Center(
            child: Text(
              "\$30,000",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp,
              ),
            ),
          ),
          SizedBox(height: 10.w),
          Container(
            height: 22,
            decoration: BoxDecoration(
              color: Color(0xfa0AB29f),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: 190,
            child: Text(
              "Depositamos: 5min",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 10.w),
          Container(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/max_page_yes.png",
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Plazo：Maximo 180 dias",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.sp,
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 2.w),
          Container(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/max_page_yes.png",
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Tasa de interes：0.09%/dia",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.sp,
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 1.w),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/signin.png",
                                    width: 25.w,
                                    height: 25.w,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Verificar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff686868),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/credit_exchange.png",
                                    width: 25.w,
                                    height: 25.w,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Auditoria",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff686868),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/Invite_friends.png",
                                    width: 25.w,
                                    height: 25.w,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Obtener dinero",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff686868),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.w),
                        AppButton(
                            title: "SOLICITAR AHORA!",
                            bgColor: Color.fromARGB(255, 110, 215, 170),
                            // onTap: logic.submit,
                            onTap: (() => {customStyle()})),
                        SizedBox(height: 22.w),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Quedan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff686868),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                color: Color.fromARGB(255, 151, 223, 194),
                                width: 60,
                                child: Text(
                                  "2000",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "vacantes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff686868),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/dot_icon1.png",
                            width: 25.w,
                            height: 25.w,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Declaracion",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 19.sp,
                            ),
                          ),
                          SizedBox(width: 8),
                          Image.asset(
                            "assets/images/dot_icon2.png",
                            width: 25.w,
                            height: 25.w,
                          ),
                        ],
                      ),
                      SizedBox(height: 18.w),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "1",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ".Presentamos mucha atencion de proteger la privacidadde clientes,los que no habia conseguido prestamos,sus datos se eliminaran automaticamente despues de 1 semana.",
                              style: TextStyle(
                                color: Color(0xff716F6F),
                                fontWeight: FontWeight.normal,
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.w),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "2",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ". Subiremos la cuota del credito hasta \$5 ,000 para quienes reembolsar al tiempo.",
                              style: TextStyle(
                                color: Color(0xff716F6F),
                                fontWeight: FontWeight.normal,
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.w),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "3",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                            ),
                            TextSpan(
                              text: ". Ofrecemos prestamos(desde 18 anos)",
                              style: TextStyle(
                                color: Color(0xff716F6F),
                                fontWeight: FontWeight.normal,
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  void customStyle() {
    if (dialog != null && dialog!.isShowing()) {
      return;
    }

    dialog = UpdateDialog.showUpdate(Get.context!,
        title: ' Nueva versión disponible',
        updateContent: 'Por favor, actualice a la última versión\n',
        titleTextSize: 18,
        contentTextSize: 16,
        buttonTextSize: 18,
        topImage: Image.asset('assets/images/update_icon.png'),
        extraHeight: 20,
        radius: 8,
        themeColor: const Color(0xff0AB27D),
        width: 320.w,
        // isForce: true,
        updateButtonText: 'Confirmar ',
        onUpdate: () {});
  }
}
