import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quick/binding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sp_util/sp_util.dart';

import 'config/config.dart';
import 'lang/translation.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SpUtil.getInstance();
  LogUtil.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

/// 继承WidgetsBindingObserver
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit(); //1. call BotToastInit

    return ScreenUtilInit(
      designSize: const Size(375, 667),
      builder: (ctx, child) => GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: RefreshConfiguration(
          child: GetMaterialApp(
            themeMode: ThemeMode.light,
            translations: Translation(),
            initialBinding: AppBinding(),
            supportedLocales: const [
              Locale('en'),
              Locale('zh'),
            ],
            locale: Translation.locale,
            fallbackLocale: Translation.fallbackLocale,
            title: Config.appName,
            smartManagement: SmartManagement.keepFactory,
            navigatorObservers: [BotToastNavigatorObserver()],
            builder: (ctx, widget) {
              widget =
                  FlutterEasyLoading(child: botToastBuilder(context, widget));

              return MediaQuery(
                ///Setting font does not change with system font size
                data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
                child: Scaffold(
                  body: widget,
                  resizeToAvoidBottomInset: false,
                ),
              );
            },
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              RefreshLocalizations.delegate,
            ],
            initialRoute: Routes.initialRoute,
            getPages: Routes.pages,
          ),
        ),
      ),
    );
  }
}
