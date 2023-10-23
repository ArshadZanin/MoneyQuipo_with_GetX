import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/refactored/controllers/transaction_controller.dart';
import 'package:money_management/refactored/database/category_db.dart';
import 'package:money_management/refactored/database/transaction_db.dart';
import 'package:money_management/refactored/models/category.dart';
import 'package:money_management/refactored/models/transaction.dart';

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

  Future<void> initialize() async {
    dateTimeController.text = format.format(dateTime.value);
    await fetchCategories();
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

  Future<void> onUpdate() async {}
}
