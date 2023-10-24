import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/shared_pref_controller.dart';

enum UserInputStep { newInput, confirm }

class SecurityController extends GetxController {
  final pref = Get.find<SharedPrefController>();

  bool setPasscode = false;

  final GlobalKey<ShakeXState> shakeKey = GlobalKey<ShakeXState>();

  RxString userInput = RxString('');
  RxString userInput2 = RxString('');
  Rx<String?> security = Rx<String?>(null);

  RxBool isError = RxBool(false);
  RxInt errorCount = RxInt(0);
  RxString errorText = RxString('');

  Rx<UserInputStep> step = Rx<UserInputStep>(UserInputStep.newInput);

  Future<void> initialize(
    bool isSetPasscode,
    Function(String?) onSuccess,
  ) async {
    setPasscode = isSetPasscode;
    security.value = pref.getSecurity();
    if (!setPasscode) {
      if (security.value == null) {
       await pref.updateSecurity();
        await onSuccess(null);
      }
    }
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

  Future<void> addNum(
    int number,
    Function(String?) onSuccess,
  ) async {
    if (userInput.value.length >= 4) return;
    userInput.value = userInput.value + '$number';
    if (userInput.value.length >= 4) {
      if (!setPasscode) {
        if (userInput.value == security.value) {
          await onSuccess(security.value);
        } else {
          onError();
        }
      } else {
        if (security.value != null) {
          if (userInput.value == security.value) {
            step.value = UserInputStep.newInput;
            errorText.value = '';
            userInput.value = '';
            userInput2.value = '';
            security.value = null;
          } else {
            onError();
          }
        } else {
          if (step.value == UserInputStep.newInput) {
            step.value = UserInputStep.confirm;
            userInput2.value = userInput.value;
            userInput.value = '';
            errorText.value = '';
          } else if (step.value == UserInputStep.confirm) {
            if (userInput.value == userInput2.value) {
              await onSuccess(userInput.value);
              step.value = UserInputStep.newInput;
              errorText.value = '';
              userInput.value = '';
              userInput2.value = '';
            } else {
              errorText.value = 'Passcodes not matching';
              shakeKey.currentState?.controller.forward(from: 0);
              shakeKey.currentState?.controller.addListener(() {
                if (shakeKey.currentState?.controller.isCompleted ?? false) {
                  isError.value = false;
                  shakeKey.currentState?.controller.removeListener(() {});
                }
              });
              step.value = UserInputStep.newInput;
              userInput.value = '';
              userInput2.value = '';
            }
          }
        }
      }
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
