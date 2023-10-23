import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/shared_pref_controller.dart';
import 'package:money_management/refactored/core/database/category_db.dart';
import 'package:money_management/refactored/core/database/transaction_db.dart';
import 'package:money_management/refactored/screens/home_screen.dart';
import 'package:money_management/refactored/screens/security_screen.dart';

class SplashController extends GetxController {
  final sharedPrefController = Get.put(SharedPrefController());
  Future<void> initialize() async {
    await Get.put(TransactionDb()).initializeDB();
    await Get.put(CategoryDb()).initializeDB();
    if (sharedPrefController.isSecured()) {
      Get.offAll(() => const SecurityScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }
}
