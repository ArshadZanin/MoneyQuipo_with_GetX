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

  bool setReminder() {
    return prefs.getBool('setReminder') ?? false;
  }

  String? getSecurity() {
    return prefs.getString('security');
  }

  void updateSecurity({
    String? security,
  }) {
    if (security == null) {
      prefs.setBool('isSecured', false);
      prefs.remove('security');
    } else {
      prefs.setBool('isSecured', true);
      prefs.setString('security', security);
    }
  }
}
