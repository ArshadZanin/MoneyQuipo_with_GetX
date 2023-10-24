import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController extends GetxController {
  late SharedPreferences prefs;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isSecured() {
    return prefs.getBool('isSecured') ?? false;
  }

  bool getReminder() {
    return prefs.getBool('setReminder') ?? false;
  }

  Future<void> setReminder(bool setReminder) async {
    await prefs.setBool('setReminder', setReminder);
  }

  String? getSecurity() {
    return prefs.getString('security');
  }

  Future<void> updateSecurity({
    String? security,
  }) async {
    if (security == null) {
      await prefs.setBool('isSecured', false);
      await prefs.remove('security');
    } else {
      await prefs.setBool('isSecured', true);
      await prefs.setString('security', security);
    }
  }
}
