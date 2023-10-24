import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/refactored/core/controllers/transaction_controller.dart';
import 'package:money_management/refactored/core/database/transaction_db.dart';
import 'package:money_management/refactored/core/models/transaction.dart';

class AccountDetailsController extends GetxController {
  final transactionDb = Get.put(TransactionDb());

  final transactionController = Get.put(TransactionController());

  DateFormat format = DateFormat('dd - MMM - yyyy, hh:ss aa');

  RxDouble assets = RxDouble(0);
  RxDouble liabilities = RxDouble(0);

  List filters = [
    'Total',
    'Annual',
    'Monthly',
    'Today',
  ];

  Future<void> fetchTransactions() async {
    await transactionController.fetchTransactions();
    calculateAmounts();
  }

  void calculateAmounts() {
    assets.value = 0;
    liabilities.value = 0;
    for (final transaction in transactionController.transactions) {
      if (transaction.account == AccountType.asset) {
        assets.value = assets.value + (transaction.amount?.toDouble() ?? 0);
      } else {
        liabilities.value =
            liabilities.value + (transaction.amount?.toDouble() ?? 0);
      }
    }
  }
}
