import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quick/constants/colors.dart';
import 'package:flutter_quick/modules/auth/policy_widget.dart';
import 'package:flutter_quick/widgets/buttons/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class PermissionPage extends StatelessWidget {
  final PermissionLogic logic = Get.put(PermissionLogic());
  final PermissionState state = Get.find<PermissionLogic>().state;

  PermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionLogic>(
      builder: (logic) {
        return Scaffold(
          backgroundColor: Color(0xfe999990),
          body: layoutSubviews(logic),
        );
      },
    );
  }

  Widget layoutSubviews(PermissionLogic logic) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Image(
                        image: AssetImage("assets/images/login_head_icon.png"),
                        width: 100.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  createPermissionView("SMS",
                      "Recopilar y monitorear los mensajes de texto financieros y no personales para obtener detalles y montos de transacciones. Se utilizarán para valorar la caificación y evaluar el riesgo del cliente. Otros mensajes no serán evaluados. Verificamos y rastreamos las transacciones financieras de los usuarios analizando sus mensajes en segundo plano y tomamos decisiones inteligentes sobre los límites de crédito basados en la evaluación de su presupuesto de gastos y capacidad de pago. No recopilaremos, leeremos ni almacenaremos sus mensajes de texto personales de su bandeja de entrada h5.mxdinero.com"),
                  createPermissionView("Lista de contactos",
                      "Cuando nos conceda permisos de libreta de direcciones, recopilaremos todos sus contactos de libreta de direcciones, incluyendo el nombre del contacto telefónico, el número de teléfono, la fecha de adición del contacto.Para detectar materiales de referencia fiables y realizar análisis de riesgos. Al mismo tiempo, la información de contacto se utilizará para rellenar el formulario de solicitud y la información de contacto se rellenará automáticamente.Además, esta información se utilizará para servicios antifraude. La información de contacto se cifrará y se cargará en nuestro servidor, la dirección es h5.mxdinero.com que solo se utiliza para servicios antifraude y evaluación crediticia. No venderemos, intercambiaremos ni alquilaremos sus comunicaciones a ningún tercero."),
                  createPermissionView("Aplicaciones instaladas",
                      "También leeremos una lista de aplicaciones instaladas en su dispositivo, incluyendo el nombre de la aplicación, el tiempo de instalación, la versión instalada, etc. Esto se utilizará para detectar la presencia de malware, trampas, manteniendo así la seguridad del entorno del sistema móvil y el servicio de préstamo.La dirección del servidor es h5.mxdinero.com, que solo se utiliza para servicios antifraude y evaluación crediticia. No venderemos, intercambiaremos ni alquilaremos la información de su lista de aplicaciones a ningún tercero."),
                  createPermissionView("Ubicación",
                      "Necesitamos la autorización de ubicación de su dispositivo para recopilar información de ubicación, que incluye información relacionada con la ubicación, como el método de ubicación del dispositivo del usuario, la hora de ubicación, la longitud, la latitud, la ubicación, el código de área de ubicación, etc.Esto se utilizará para confirmar su calificación crediticia y aumentar la seguridad de su cuenta a través de la información de su ubicación. Le notificaremos de inmediato cuando se detecte una anomalía. La información de ubicación se cifrará y se cargará en nuestro servidor en h5.mxdinero.com, que solo se utiliza para servicios antifraude y evaluación crediticia. No venderemos, intercambiaremos ni alquilaremos su información de ubicación a ningún tercero."),
                  createPermissionView("Almacenamiento",
                      "Para toda la información recopilada, la almacenaremos en el servidor de Tala Dinero de una manera altamente protegida. La dirección del servidor es h5.mxdinero.com. No venderemos, intercambiaremos ni alquilaremos su información a ningún tercero."),
                  createPermissionView("Cámara",
                      "Utilizar cámaras para tomar los documentosy/ o las fotografías necesarios para el proceso de solicitud y evaluación."),
                  createPermissionView("Información de dispositivo",
                      "Permiso para recopilar y monitorear información específica sobre su dispositivo, incluido el nombre de su dispositivo, modelo, configuración de región e idioma, código de identificación del dispositivo, información de hardware y software del dispositivo, estado, hábitos de uso, IMEI y número de serie y otros identificadores únicos de dispositivo para poder identificar de forma única el Dispositivo y así asegurarse que los dispositivos no autorizados no puedan actuar en su nombre, previniendo cualquier tipo de fraude.El dispositivo de información de ubicación se cifrará y se cargará en nuestro servidor h5.mxdinero.com, que solo se utiliza para servicios antifraude y evaluación crediticia. No venderemos, comercializamos o alquilamos la información de su dispositivo a terceros.")
                ],
              ),
            )),
            SizedBox(height: 15.w),
            AppButton(
              title: "Siguiente",
              bgColor: Color.fromARGB(255, 92, 211, 177),
              onTap: logic.submit,
            ),
            SizedBox(height: 15.w),
          ],
        ),
      ),
    );
  }

  Widget createPermissionView(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 0.w),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    "assets/images/choose.png",
                    width: 30.w,
                    height: 30.w,
                  ),
                ),
              ),
            ],
          ),
          Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff5A5A5B),
              fontWeight: FontWeight.normal,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 15.w),
        ],
      ),
    );
  }
}
