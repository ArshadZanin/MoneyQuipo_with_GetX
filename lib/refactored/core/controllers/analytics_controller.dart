import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/refactored/core/controllers/transaction_controller.dart';
import 'package:money_management/refactored/core/database/transaction_db.dart';
import 'package:money_management/refactored/core/enums/filter.dart';
import 'package:money_management/refactored/core/models/transaction.dart';

class AnalyticsController extends GetxController {
  final transactionDb = Get.put(TransactionDb());
  final transactionController = Get.put(TransactionController());

  Rx<Filter> filter = Rx<Filter>(Filter.total);
  Rx<TransactionType> transactionType =
      Rx<TransactionType>(TransactionType.income);

  RxList<PieData> datas = RxList<PieData>();

  Future<void> fetchTransactions() async {
    await transactionController.fetchTransactions();
    convertToPieData();
  }

  void convertToPieData() {
    datas.clear();

    final transactions = transactionController.transactions;

    ///filtering part
    final List<Transaction> filteredList = [];
    switch (filter.value) {
      case Filter.total:
        filteredList.addAll(
          transactions.where((e) => e.transactionType == transactionType.value),
        );
        break;
      case Filter.annually:
        for (final trans in transactions) {
          if (trans.dateTime?.year == DateTime.now().year &&
              trans.transactionType == transactionType.value) {
            filteredList.add(trans);
          }
        }

        break;
      case Filter.monthly:
        for (final trans in transactions) {
          if (trans.dateTime?.month == DateTime.now().month &&
              trans.transactionType == transactionType.value) {
            filteredList.add(trans);
          }
        }
        break;
      case Filter.today:
        final today = DateFormat.yMMMd();
        for (final trans in transactions) {
          if (trans.dateTime == null) continue;
          if (today.format(trans.dateTime!) == today.format(DateTime.now()) &&
              trans.transactionType == transactionType.value) {
            filteredList.add(trans);
          }
        }
        break;
    }
    Set<String> catergories = {};
    catergories = filteredList.map((e) => e.category ?? '').toSet();

    for (final String category in catergories) {
      num total = 0;
      for (final data in filteredList) {
        if (data.category == category) {
          total += data.amount ?? 0;
        }
      }
      datas.add(PieData(category, total));
    }
  }
}

class PieData {
  PieData(this.xData, this.yData);
  final String xData;
  final num yData;
}
