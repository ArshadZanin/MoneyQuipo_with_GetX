import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/splash_controller.dart';
import 'package:money_management/refactored/widgets/animation/m_animation.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Get.put(SplashController()).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: MContainer(
        child: Center(
          child: MAnimation(
            animation: QuipoAnimation.zoomIn,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/app_icon.png',
                fit: BoxFit.fitWidth,
                width: deviceWidth > 400 ? 400 : deviceWidth - 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
