import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/refactored/core/controllers/transaction_controller.dart';
import 'package:money_management/refactored/core/database/category_db.dart';
import 'package:money_management/refactored/core/database/transaction_db.dart';
import 'package:money_management/refactored/core/models/category.dart';
import 'package:money_management/refactored/core/models/transaction.dart';

class AddTransactionController extends GetxController {
  final categoryDb = Get.put(CategoryDb());
  final transactionDb = Get.put(TransactionDb());
  final transactionController = Get.put(TransactionController());

  DateFormat format = DateFormat('dd - MMM - yyyy, hh:ss aa');
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();

  Rx<TransactionType> transactionType =
      Rx<TransactionType>(TransactionType.income);
  Rx<AccountType> accountType = Rx<AccountType>(AccountType.asset);

  Rx<DateTime> dateTime = Rx<DateTime>(DateTime.now());

  RxList<String> catergories = RxList<String>();
  Rx<String?> catergory = Rx<String?>(null);

  Future<void> initialize(Transaction? transaction) async {
    await fetchCategories();
    if (transaction != null) {
      transactionType.value =
          transaction.transactionType ?? TransactionType.income;
      accountType.value = transaction.account ?? AccountType.asset;
      dateTime.value = transaction.dateTime ?? DateTime.now();
      if (catergories.contains(transaction.category)) {
        catergory.value = transaction.category;
      }
      amount.text = '${transaction.amount ?? ''}';
      note.text = '${transaction.note ?? ''}';
    } else {
      transactionType.value = TransactionType.income;
      accountType.value = AccountType.asset;
      dateTime.value = DateTime.now();
      catergory.value = null;

      amount.text = '';
      note.text = '';
    }
    dateTimeController.text = format.format(dateTime.value);
  }

  Future<void> fetchCategories() async {
    final datas = await categoryDb.fetchCategories(
      type: transactionType.value,
    );
    catergories.value = datas.map((e) => e.name ?? '').toList();
  }

  Future<void> addCategory(String name) async {
    final category = Category(
      name: name,
      type: transactionType.value,
    );
    await categoryDb.insetCategory([category]);
    catergories.add(name);
  }

  Future<void> onSave() async {
    final transaction = Transaction(
      dateTime: dateTime.value,
      transactionType: transactionType.value,
      account: accountType.value,
      amount: num.tryParse(amount.text),
      note: note.text,
      category: catergory.value,
    );
    await transactionDb.createTransaction([transaction]);
    await transactionController.fetchTransactions();
  }

  Future<void> onUpdate(Transaction transaction) async {
    final updatedTrans = Transaction(
      id: transaction.id,
      dateTime: dateTime.value,
      transactionType: transactionType.value,
      account: accountType.value,
      amount: num.tryParse(amount.text),
      note: note.text,
      category: catergory.value,
    );
    await transactionDb.updateTransaction(transaction:updatedTrans,);
    await transactionController.fetchTransactions();

  }
}
