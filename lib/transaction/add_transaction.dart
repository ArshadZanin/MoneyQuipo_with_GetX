// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:money_management/color/app_color.dart' as app_color;
import 'package:money_management/db/database_expense_category.dart';
import 'package:money_management/db/database_income_category.dart';
import 'package:money_management/db/database_transaction.dart';
import 'package:money_management/splash%20screen/splash_screen.dart';
import 'package:money_management/widgets/widget_controller.dart';

class AddTrans extends StatefulWidget {
  final User? transaction;
  final int? transactionIndex;

  final IncomeCategoryDb? user;
  final int? userIndex;

  final ExpenseCategoryDb? user1;
  final int? userIndex1;

  const AddTrans(
      {this.transaction,
      this.transactionIndex,
      this.user,
      this.userIndex,
      this.user1,
      this.userIndex1,
      Key? key})
      : super(key: key);

  @override
  _AddTransState createState() => _AddTransState();
}

class _AddTransState extends State<AddTrans> {
  final widgets = Get.put(WidgetController());

  String? _incomeCategory;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  String? _expenseCategory;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  int section = 0;

  late var _saveDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

  String _transaction = 'income';
  // String _saveDate;
  String? _account = 'Assets';
  String? _category = '<select>';
  String? _amount;
  String? _note;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DatabaseHandler handler;
  late DatabaseHandlerIncomeCategory handlerIncome;
  late DatabaseHandlerExpenseCategory handlerExpense;

  List<String>? incomeCate;
  List<String>? expenseCate;

  var income12 = [];
  var expense12 = [];

  var incomeCategory = ['<select>'];
  var expenseCategory = ['<select>'];

  @override
  void initState() {
    super.initState();
    if (widget.user1 != null) {
      _expenseCategory = widget.user1!.expenseCategory;
    }
    if (widget.user != null) {
      _incomeCategory = widget.user!.incomeCategory;
    }
    incomeCate ??= ['Cash'];
    expenseCate ??= ['Food'];
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      // await this.addUsers();
      setState(() {});
    });

    ///income Category to list///
    handlerIncome = DatabaseHandlerIncomeCategory();
    handlerIncome.initializeDB().whenComplete(() async {
      final List incomeCate12 = await handlerIncome.listIncomeCategory();
      if (incomeCate12.isEmpty) {
        incomeCate12.add('Cash');
      } else {
        incomeCate12.toSet().toList();
      }
      incomeCate = [...incomeCate12];
      for (int i = 0; i < incomeCate!.length; i++) {
        incomeCategory.add(incomeCate![i]);
      }
      setState(() {});
    });

    ///expense category to list///
    handlerExpense = DatabaseHandlerExpenseCategory();
    handlerExpense.initializeDB().whenComplete(() async {
      final List expenseCate12 = await handlerExpense.listExpenseCategory();
      if (expenseCate12.isEmpty) {
        expenseCate12.add('Cash');
      } else {
        expenseCate12.toSet().toList();
      }
      expenseCate = [...expenseCate12];
      for (int i = 0; i < expenseCate!.length; i++) {
        expenseCategory.add(expenseCate![i]);
      }
      setState(() {});
    });

    if (widget.transaction != null) {
      _transaction = widget.transaction!.trans!;
      if(_transaction == 'income'){
        section = 0;
      }else{
        section = 1;
      }
      _saveDate = widget.transaction!.date!;
      _account = widget.transaction!.account;
      // _category = widget.transaction!.category;
      _amount = widget.transaction!.amount!;
      _note = widget.transaction!.note;
    }
    setState(() {});
  }

  Widget _buildItem() {
    return TextFormField(
      initialValue: _incomeCategory,
      decoration: const InputDecoration(
          labelText: 'Income Category',
          hoverColor: Colors.black,
          fillColor: Colors.black,
          focusColor: Colors.black),
      maxLength: 15,
      style: const TextStyle(color: Colors.black),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Category is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _incomeCategory = value;
      },
      textAlign: TextAlign.left,
    );
  }

  Widget _buildItem1() {
    return TextFormField(
      initialValue: _expenseCategory,
      decoration: const InputDecoration(
          labelText: 'Expense Category',
          hoverColor: Colors.black,
          fillColor: Colors.black,
          focusColor: Colors.black),
      maxLength: 15,
      style: const TextStyle(color: Colors.black),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Category is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _expenseCategory = value;
      },
      textAlign: TextAlign.left,
    );
  }

  final _dateController = TextEditingController(
      text: DateFormat('MMM dd, yyyy').format(DateTime.now()));
  Widget _buildDate(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
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
            }
          });
        },
        decoration: const InputDecoration(labelText: 'Date'),
        style: const TextStyle(fontSize: 15),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Date is Required';
          }
          return null;
        },
        onSaved: (String? value) {
          _saveDate = value!;
        },
      ),
    );
  }

  Widget _buildAccount() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          const Text('Account:\t\t'),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              items: <String>['Assets', 'Liabilities']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _account,
              onChanged: (String? newValue) {
                setState(() {
                  _account = newValue!;
                });
              },
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 0,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory1() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          const Text('Category:\t\t'),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: const Text('<select>'),
              items:
                  incomeCategory.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _category,
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue!;
                });
              },
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 0,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory2() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          const Text('Category:\t\t'),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: const Text('<select>'),
              items:
                  expenseCategory.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _category,
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue!;
                });
              },
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 0,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        initialValue: _amount,
        decoration: const InputDecoration(labelText: 'Amount'),
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 15),
        validator: (String? value) {
          final int? amount = int.tryParse(value!);

          if (amount == null) {
            return 'amount required';
          }

          return null;
        },
        onSaved: (String? value) {
          _amount = value;
        },
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        initialValue: _note,
        decoration: const InputDecoration(labelText: 'Note'),
        maxLength: 30,
        style: const TextStyle(fontSize: 15),
        onSaved: (String? value) {
          _note = value;
        },
      ),
    );
  }

  @Deprecated('message')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.indigo,v
      appBar: AppBar(
        elevation: 0.2,
        title: Text(
          section == 0 ? 'Income' : 'Expense',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(children: [
        Container(
          color: app_color.back,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                section == 0
                    ? FlatButton(
                        splashColor: Colors.white,
                        hoverColor: Colors.white,
                        focusColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _category = '<select>';
                            section = 0;
                            _transaction = 'income';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue)),
                          child: const Text(
                            'Income',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      )
                    : FlatButton(
                        splashColor: Colors.white,
                        hoverColor: Colors.white,
                        focusColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _category = '<select>';
                            section = 0;
                            _transaction = 'income';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: const Text(
                            'Income',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ),
                section != 0
                    ? FlatButton(
                        splashColor: Colors.white,
                        hoverColor: Colors.white,
                        focusColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _category = '<select>';
                            section = 1;
                            _transaction = 'expense';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red)),
                          child: const Text(
                            'Expense',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ),
                      )
                    : FlatButton(
                        splashColor: Colors.white,
                        hoverColor: Colors.white,
                        focusColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _category = '<select>';
                            section = 1;
                            _transaction = 'expense';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: const Text(
                            'Expense',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ),
              ],
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width - 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildDate(context),
                    _buildAccount(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        section == 0 ? _buildCategory1() : _buildCategory2(),
                        section == 0
                            ? IconButton(
                                onPressed: () {
                                  debugPrint('blue Clicked');
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => ListView(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 150,
                                            child: Form(
                                              key: _formKey1,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white,
                                                    ),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        _buildItem(),
                                                      ],
                                                    ),
                                                  ),
                                                  Center(
                                                    child: widgets.submitButton(()async{
                                                      if (!_formKey1
                                                          .currentState!
                                                          .validate()) {
                                                        return;
                                                      }

                                                      _formKey1.currentState!
                                                          .save();
                                                      debugPrint('saved');
                                                      final IncomeCategoryDb
                                                      user =
                                                      IncomeCategoryDb(
                                                          incomeCategory:
                                                          _incomeCategory);

                                                      final List<
                                                          IncomeCategoryDb>
                                                      listofIncomeCategoryDb =
                                                      [user];

                                                      final DatabaseHandlerIncomeCategory
                                                      db =
                                                      DatabaseHandlerIncomeCategory();

                                                      await db.insertIncomeCategory(
                                                          listofIncomeCategoryDb);

                                                      debugPrint('insert');
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                              const AddTrans()));
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => ListView(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 150,
                                            child: Form(
                                              key: _formKey2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white,
                                                    ),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        _buildItem1(),
                                                      ],
                                                    ),
                                                  ),
                                                  Center(
                                                    child: widgets.submitButton(() async{
                                                      if (!_formKey2
                                                          .currentState!
                                                          .validate()) {
                                                        return;
                                                      }

                                                      _formKey2.currentState!
                                                          .save();
                                                      final ExpenseCategoryDb
                                                      user1 =
                                                      ExpenseCategoryDb(
                                                          expenseCategory:
                                                          _expenseCategory);

                                                      final List<
                                                          ExpenseCategoryDb>
                                                      listofExpenseCategoryDb =
                                                      [user1];

                                                      final DatabaseHandlerExpenseCategory
                                                      db =
                                                      DatabaseHandlerExpenseCategory();

                                                      await db.insertExpenseCategory(
                                                          listofExpenseCategoryDb);
                                                      debugPrint('insert');
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                              const AddTrans()));
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.red,
                                )),
                      ],
                    ),
                    _buildAmount(),
                    _buildNote(),
                    widget.transaction == null ?
                    RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      color: Colors.indigo,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (_category == '<select>' && section == 0) {
                          _category = 'Cash';
                        } else if (_category == '<select>' && section == 1) {
                          _category = 'Food';
                        }

                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        _formKey.currentState!.save();

                        final User student = User(
                            trans: _transaction,
                            date: _saveDate,
                            account: _account,
                            category: _category,
                            amount: _amount,
                            note: _note);

                        final List<User> listOfUser = [student];

                        final db = Get.put(DatabaseHandler());

                        await db.insertUser(listOfUser);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageAssist(),
                          ),
                        );
                      },
                    ) :
                    RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      color: Colors.indigo,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (_category == '<select>' && section == 0) {
                          _category = 'Cash';
                        } else if (_category == '<select>' && section == 1) {
                          _category = 'Food';
                        }

                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        _formKey.currentState!.save();

                        final db = Get.put(DatabaseHandler());

                        await db.updateUser(
                            id: widget.transactionIndex!,
                            trans: _transaction,
                            date: _saveDate,
                            account: _account!,
                            category: _category!,
                            amount: _amount!,
                            note: _note!
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageAssist(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
