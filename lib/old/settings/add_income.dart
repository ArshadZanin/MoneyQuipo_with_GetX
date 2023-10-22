// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// Project imports:
import 'package:money_management/old/color/app_color.dart' as app_color;
import 'package:money_management/old/db/database_income_category.dart';
import 'package:money_management/old/settings/income_category.dart';
import 'package:money_management/old/widgets/widget_controller.dart';

class AddIncomeData extends StatefulWidget {
  final IncomeCategoryDb? income;
  final int? incomeIndex;

  const AddIncomeData({this.income, this.incomeIndex, Key? key})
      : super(key: key);

  @override
  State<AddIncomeData> createState() => _AddIncomeDataState();
}

class _AddIncomeDataState extends State<AddIncomeData> {
  final widgets = Get.put(WidgetController());

  String? _incomeCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.income != null) {
      _incomeCategory = widget.income!.incomeCategory;
    }
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

  @Deprecated('message')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.back,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF020925),
        title: const Text(
          'Add income category',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItem(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.income == null
                ? Center(
                    child: widgets.submitButton(() async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      _formKey.currentState!.save();
                      final IncomeCategoryDb user =
                          IncomeCategoryDb(incomeCategory: _incomeCategory);

                      final List<IncomeCategoryDb> listofIncomeCategoryDb = [
                        user
                      ];

                      final db = Get.put(DatabaseHandlerIncomeCategory());

                      await db.insertIncomeCategory(listofIncomeCategoryDb);
                      db.update();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const IncomeCategory()));
                      Navigator.pop(context);
                    }),
                  )
                : Center(
                    child: widgets.submitButton(() async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      _formKey.currentState!.save();

                      final db = Get.put(DatabaseHandlerIncomeCategory());

                      await db.updateIncomeCategory(
                          widget.incomeIndex!, _incomeCategory!);
                      db.update();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const IncomeCategory()));
                      Navigator.pop(context);
                    }),
                  ),
          ],
        ),
      ),
    );
  }
}
