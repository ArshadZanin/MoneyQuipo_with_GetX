import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class MSnackbar {
  static void success(String message) {
    Get.snackbar(
      'Success',
      message,
      titleText: const MText(
        text: 'Success',
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      messageText: MText(
        text: message,
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade300,
    );
  }

  static void error(String message) {
    Get.snackbar(
      'Error!!',
      message,
      titleText: const MText(
        text: 'Error!!',
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      messageText: MText(
        text: message,
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade300,
    );
  }
}
