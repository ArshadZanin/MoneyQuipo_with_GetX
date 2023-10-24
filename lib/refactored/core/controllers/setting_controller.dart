import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/shared_pref_controller.dart';

class SettingsController extends GetxController {
  final pref = Get.put(SharedPrefController());

  RxBool appLock = RxBool(false);
  RxBool setReminder = RxBool(false);

  void initialize() {
    appLock.value = pref.isSecured();
    setReminder.value = pref.getReminder();
  }
}
