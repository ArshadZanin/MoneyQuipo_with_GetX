// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:money_management/getx_controller/transactions_controller.dart';
import 'package:money_management/transaction/add_transaction.dart';
import 'package:money_management/widgets/widget_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:money_management/color/app_color.dart' as app_color;
import 'db/database_transaction.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {

  final widgets = Get.put(WidgetController());

  // double? income = 0.0;
  // double? expense = 0.0;
  // double? balance = 0.0;

  // int flag = 0;

  // List<String> listDate = [];

  final _dateController = TextEditingController(
      text: DateFormat('MMM dd, yyyy').format(DateTime.now()));

  final handler = Get.put(DatabaseHandler());
  final values = Get.put(TransactionController());



  @override
  void initState() {
    super.initState();
    handler.initializeDB().whenComplete(() async {

      values.dataTake();
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  double percentBar(double income, double expense){
    if(expense < income){
      double value1 = (expense / income) - 1;
      if(value1 < 0){
        value1 = value1 * -1;
      }
      return value1;
    }else if(expense > income){
      double value2 = 1 - (income / expense);
      if(value2 < 0){
        value2 = value2 * -1;
      }
      return value2;
    }else{
      return 0.0;
    }
  }

  int countIs(int count) {
    count++;
    return count;
  }

  @Deprecated('message')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: app_color.back,
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 100,
            child: Center(
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                ),
                readOnly: true,
                keyboardType: TextInputType.none,
                controller: _dateController,
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now(),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      _dateController.text =
                          DateFormat('MMM dd, yyyy').format(selectedDate);
                      for (int i = 0; i < values.listDate.length; i++) {
                        if (values.listDate[i] == _dateController.text) {
                          values.flag = 1.obs;
                          break;
                        } else {
                          values.flag = 0.obs;
                        }
                      }
                      setState(() {});
                      handler.initializeDB().whenComplete(() async {
                        values.dataTake();
                        setState(() {});
                      });
                    }
                  });
                },
                style: const TextStyle(fontSize: 15, color: Colors.black),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Date is Required';
                  }
                  return null;
                },
                onSaved: (String? value) {
                },
              ),
            ),
          )
        ],
        backgroundColor: app_color.appBar,
        title: const Text(
          'MoneyQuipo',
          style: TextStyle(color: app_color.text, letterSpacing: 1),
        ),
        elevation: 0.2,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widgets.boxH(10),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widgets.boxW(10),
                widgets.earnedSpentWidget(
                    context: context,
                    shadowColor: app_color.shadowGreen,
                    mainColor1: app_color.greenBox1,
                    mainColor2: app_color.greenBox2,
                    heading: 'Earned',
                    value: '+${values.income}',
                    name: 'income'
                ),
                widgets.boxW(10),
                widgets.earnedSpentWidget(
                    context: context,
                    shadowColor: app_color.shadowRed,
                    mainColor1: app_color.redBox1,
                    mainColor2: app_color.redBox2,
                    heading: 'Spent',
                    value: '-${values.expense}',
                    name: 'expense'
                ),
                widgets.boxW(10),
              ],
            ),),
            widgets.boxH(10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                elevation: 5,
                shadowColor: const Color(0xff4792ff),
                borderRadius: BorderRadius.circular(10),
                color: app_color.widget,
                // margin: const EdgeInsets.symmetric(horizontal: 10),

                child: Column(
                  children: [
                    const Text(
                      'Budget so far',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Obx(() => LinearPercentIndicator(
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2000,
                          percent: percentBar(
                              double.parse('${values.income}'),
                              double.parse('${values.expense}')
                          ),
                          center: double.parse('${values.income}') - double.parse('${values.expense}') < 0
                              ? Text(
                            '${double.parse('${values.income}') - double.parse('${values.expense}')}',
                            style: const TextStyle(
                              color: Color(0xffb10000),
                              letterSpacing: 1,
                            ),
                          )
                              : Text(
                            '${double.parse('${values.income}') - double.parse('${values.expense}')}',
                            style: const TextStyle(
                              color: Color(0xFFffffff),
                              letterSpacing: 1,
                            ),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: double.parse('${values.expense}') <= double.parse('${values.income}')
                              ? Colors.lightBlueAccent
                              : Colors.redAccent,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widgets.boxH(10),
            const Text(
              'Transactions',
              style: TextStyle(color: app_color.text, fontSize: 15),
            ),
            widgets.boxH(4),
            '${values.flag}' != '1'
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_to_photos_sharp,
                            size: 50,
                            color: Colors.black26,
                          ),
                          Text(
                            'No Transaction available!',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
               : Expanded(
                    child: GetBuilder<DatabaseHandler>(
                      builder: (GetxController controller) {
                        return FutureBuilder(
                          future: handler.retrieveUsers(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<User>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  index = snapshot.data!.length - index - 1;
                                  return Dismissible(
                                    confirmDismiss: (DismissDirection direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirm'),
                                            content: const Text(
                                                'Are you sure you wish to delete this item?'),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(true),
                                                  child: const Text(
                                                    'DELETE',
                                                    style: TextStyle(color: Colors.red),
                                                  )),
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(false),
                                                child: const Text('CANCEL'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: const Icon(Icons.delete_forever),
                                    ),
                                    key: ValueKey<int>(snapshot.data![index].id!),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await handler
                                          .deleteUser(snapshot.data![index].id!);
                                      setState(() {
                                        snapshot.data!
                                            .remove(snapshot.data![index]);
                                      });

                                      values.dataTake();
                                    },
                                    child: snapshot.data![index].date ==
                                        _dateController.text
                                        ? Card(
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 4
                                      ),
                                      elevation: 3,
                                      color: app_color.list,
                                      child: ListTile(
                                        onLongPress: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AddTrans(
                                                  transaction: snapshot.data![index],
                                                  transactionIndex: snapshot.data![index].id,)));
                                        },
                                        onTap: () {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                    'Date: ${snapshot.data![index]
                                                        .date}'
                                                        '\nTransaction: ${snapshot
                                                        .data![index].trans}'
                                                        '\nAccount: ${snapshot
                                                        .data![index].account}'
                                                        '\nCategory: ${snapshot
                                                        .data![index].category}'
                                                        '\nNote: ${snapshot
                                                        .data![index].note}',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Amount: ${snapshot
                                                        .data![index].amount
                                                        .toString()}',
                                                    style: snapshot.data![index]
                                                        .trans ==
                                                        'income'
                                                        ? const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 20)
                                                        : const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(
                                                            context, 'Go Back');
                                                      },
                                                      child: const Text(
                                                        'Go Back',
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        trailing: snapshot.data![index].trans ==
                                            'income'
                                            ? widgets.amountTextWidget(
                                            '+ ${snapshot.data![index]
                                                .amount.toString()}',
                                            Colors.green)
                                            : widgets.amountTextWidget(
                                            '- ${snapshot.data![index]
                                                .amount.toString()}',
                                            Colors.red),
                                        contentPadding:
                                        const EdgeInsets.all(9.0),
                                        title: Text(
                                          '${snapshot.data![index].category!}'
                                              ' \n ${snapshot.data![index]
                                              .date}',
                                          style: const TextStyle(
                                              color: app_color.text),
                                        ),

                                        // subtitle:
                                        
                                      ),
                                    )
                                        : Container(),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}