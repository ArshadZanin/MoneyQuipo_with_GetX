import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/constants/app_colors.dart';
import 'package:money_management/refactored/core/controllers/shared_pref_controller.dart';

import 'package:money_management/refactored/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.put(SharedPrefController()).initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Management',
      theme: ThemeData(
        fontFamily: 'Saira',
        primaryColor: AppColor.shadowGreen,
      ),
      home: const SplashScreen(),
    );
  }
}
