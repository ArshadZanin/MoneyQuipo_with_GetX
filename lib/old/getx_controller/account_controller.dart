import 'package:get/get.dart';
import 'package:money_management/old/db/database_transaction.dart';

class AccountController extends GetxController {
  final handler = Get.put(DatabaseHandler());

  ///variable declaration
  var assets = 0.0.obs;
  var liabilities = 0.0.obs;
  var total = 0.0.obs;

  ///init in getX
  @override
  void onInit() {
    super.onInit();
    handler.initializeDB().whenComplete(() async {
      dataTake();
    });
  }

  ///take data from database and update the variables
  void dataTake() async {
    final String? assets12 = await handler.calculateAssetsTotal();
    assets = double.parse(assets12!).obs;

    final String? liabilities12 = await handler.calculateLiabilitiesTotal();
    liabilities = double.parse(liabilities12!).obs;
  }
}
