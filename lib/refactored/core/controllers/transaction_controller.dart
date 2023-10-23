import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/refactored/core/database/transaction_db.dart';
import 'package:money_management/refactored/core/models/transaction.dart';

class TransactionController extends GetxController {
  final transactionDb = Get.put(TransactionDb());

  DateFormat format = DateFormat('dd - MMM - yyyy, hh:ss aa');

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
    calculateAmounts();
  }

  void calculateAmounts() {
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

  Future<void> deleteTransaction(int id, int index) async {
    await transactionDb.deleteTransaction(id);
    transactions.removeAt(index);
    calculateAmounts();
  }
}