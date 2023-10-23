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
}
