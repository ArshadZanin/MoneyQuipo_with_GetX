import 'package:get/get.dart';
import 'package:money_management/refactored/database/transaction_db.dart';
import 'package:money_management/refactored/models/transaction.dart';

class TransactionController extends GetxController {
  final transactionDb = Get.put(TransactionDb());

  RxDouble income = RxDouble(0);
  RxDouble expense = RxDouble(0);

  List filters = [
    'Total',
    'Annual',
    'Monthly',
    'Today',
  ];

  RxList<Transaction> transactions = RxList<Transaction>();

  Future<void> fetchTransactions() async {
    transactions.value = await transactionDb.fetchTransactions();
    income.value = 0;
    expense.value = 0;
    for (final transaction in transactions) {
      if (transaction.transactionType == TransactionType.income) {
        income.value = income.value + (transaction.amount?.toDouble() ?? 0);
      } else {
        expense.value = expense.value + (transaction.amount?.toDouble() ?? 0);
      }
    }
  }
}
