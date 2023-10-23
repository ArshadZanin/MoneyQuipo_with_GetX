import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/shared_pref_controller.dart';
import 'package:money_management/refactored/screens/home_screen.dart';

class SecurityController extends GetxController {
  final pref = Get.find<SharedPrefController>();

  final GlobalKey<ShakeXState> shakeKey = GlobalKey<ShakeXState>();

  RxString userInput = RxString('');
  String? security;

  RxBool isError = RxBool(false);
  RxInt errorCount = RxInt(0);
  RxString errorText = RxString('');

  Future<void> initialize() async {
    security = pref.prefs.getString('security');
    if (security == null) {
      pref.prefs.setBool('isSecurity', false);
      onUnlocked();
    }
  }

  void onUnlocked() {
    Get.offAll(() => const HomeScreen());
  }

  void onError() {
    userInput.value = '';
    errorCount.value++;
    isError.value = true;
    errorText.value = 'Try again';
    shakeKey.currentState?.controller.forward(from: 0);
    shakeKey.currentState?.controller.addListener(() {
      if (shakeKey.currentState?.controller.isCompleted ?? false) {
        isError.value = false;
        shakeKey.currentState?.controller.removeListener(() {});
      }
    });
  }

  void addNum(int number) {
    if (userInput.value.length >= 4) return;
    userInput.value = userInput.value + '$number';
    if (userInput.value.length >= 4) {
      if (userInput.value == security) {
        onUnlocked();
      } else {
        onError();
      }
      return;
    }
  }

  void removeNum() {
    if (userInput.isEmpty) return;
    userInput.value = userInput.value.substring(
      0,
      userInput.value.length - 1,
    );
  }
}
