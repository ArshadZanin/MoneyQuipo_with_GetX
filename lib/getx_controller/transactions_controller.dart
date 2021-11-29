import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/db/database_transaction.dart';
import 'package:money_management/widgets/widget_controller.dart';

class TransactionController extends GetxController{


  final widgets = Get.put(WidgetController());

  ///value declarations
  var income = 0.0.obs;
  var expense = 0.0.obs;
  var balance = 0.0.obs;
  var flag = 0.obs;

  var listDate = [].obs;

  final _dateController = TextEditingController(
      text: DateFormat('MMM dd, yyyy').format(DateTime.now()));

  final handler = Get.put(DatabaseHandler());
  // final values = Get.put(TransactionController());

///init state of getX
  @override
  void onInit() {
    super.onInit();
    dataTake();
    Future.delayed(const Duration(seconds: 5), () {
      dataTake();
    });
  }

  ///this is used for take data from database and it will update the values
  void dataTake() async {
    late final _dateYear =
    _dateController.text.substring(8, _dateController.text.length);
    late final _dateMonth =
    _dateController.text.substring(0, _dateController.text.length - 9);


    ///take database list to here///
    final List<Map<String, Object?>> databaseList =
    await handler.retrieveUsersDatabase();
    // debugPrint("hello : $databaseList");

    ///take date///
    final Set<String> dateSet = {};
    for (int i = 0; i < databaseList.length; i++) {
      final String data = databaseList[i]['date'].toString();
      dateSet.add(data);
    }
    listDate = [...dateSet.toList()].obs;
    for (int i = 0; i < listDate.length; i++) {
      if (listDate[i] == _dateController.text) {
        flag = 1.obs;
      }
    }

    ///income month///
    double total = 0;
    for (int j = 0; j < databaseList.length; j++) {
      final String dateIs = databaseList[j]['date']
          .toString()
          .substring(0, databaseList[j]['date'].toString().length - 9);
      final String dateLast = databaseList[j]['date']
          .toString()
          .substring(8, databaseList[j]['date'].toString().length);
      if (dateIs == _dateMonth &&
          dateLast == _dateYear &&
          databaseList[j]['trans'] == 'income') {
        final double value = double.parse(databaseList[j]['amount']
            .toString());
        total = total + value;
      }
    }
    income = total.obs;

    ///expense month///
    double total1 = 0;
    for (int j = 0; j < databaseList.length; j++) {
      final String dateIs = databaseList[j]['date']
          .toString()
          .substring(0, databaseList[j]['date'].toString().length - 9);
      final String dateLast = databaseList[j]['date']
          .toString()
          .substring(8, databaseList[j]['date'].toString().length);
      if (dateIs == _dateMonth &&
          dateLast == _dateYear &&
          databaseList[j]['trans'] == 'expense') {
        final double value = double
            .parse(databaseList[j]['amount'].toString());
        total1 = total1 + value;
      }
    }
    expense = total1.obs;
  }

  ///this is used for check the time
  void dataCheck({required DateTime selectedDate}){
    _dateController.text =
        DateFormat('MMM dd, yyyy').format(selectedDate);
    for (int i = 0; i < listDate.length; i++) {
      if (listDate[i] == _dateController.text) {
        flag = 1.obs;
        break;
      } else {
        flag = 0.obs;
      }
    }
  }

}