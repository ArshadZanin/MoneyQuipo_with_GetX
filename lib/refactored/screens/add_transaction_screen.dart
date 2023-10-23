import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/controllers/add_transaction_controller.dart';
import 'package:money_management/refactored/models/transaction.dart';
import 'package:money_management/refactored/widgets/button/m_button.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';
import 'package:money_management/refactored/widgets/input/m_input_dropdown_field.dart';
import 'package:money_management/refactored/widgets/input/m_input_text_field.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class AddTransactionScreen extends StatefulWidget {
  AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final controller = Get.put(AddTransactionController());

  Color pageTheme = Colors.blue;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MText(
          text: 'Add transaction',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: pageTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(TransactionType.values.length, (index) {
                  final type = TransactionType.values[index];
                  return _buildTransactionType(
                    isSelected: type == controller.transactionType.value,
                    label: type.name.toUpperCase(),
                    color: pageTheme,
                    onTap: () async {
                      controller.transactionType.value = type;
                      await controller.fetchCategories();
                      pageTheme = _getPageTheme(type);
                      setState(() {});
                    },
                  );
                }),
              );
            }),
            MSpace.vertical(16),
            MInputTextField(
              label: 'Date',
              controller: controller.dateTimeController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.dateTime.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked == null) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time == null) return;
                final dateTime = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  time.hour,
                  time.minute,
                );
                controller.dateTime.value = dateTime;
                controller.dateTimeController.text =
                    controller.format.format(dateTime);
              },
            ),
            MSpace.vertical(16),
            MInputDropdownField<AccountType>(
              label: 'Account',
              value: AccountType.values.first,
              items: List.generate(AccountType.values.length, (index) {
                final type = AccountType.values[index];
                return DropdownMenuItem(
                  value: type,
                  child: MText(
                    text: type.name.toUpperCase(),
                    fontSize: 18,
                    color: Colors.black,
                  ),
                );
              }),
              onChanged: (value) {
                if (value == null) return;
                controller.accountType.value = value;
              },
            ),
            MSpace.vertical(16),
            Obx(() {
              return MInputDropdownField<String>(
                label: 'Category',
                value: controller.catergory.value,
                items: controller.catergories.isEmpty
                    ? [
                        const DropdownMenuItem<String>(
                          enabled: false,
                          value: 'No item',
                          child: MText(
                            text: 'No category available',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ]
                    : List.generate(controller.catergories.length, (index) {
                        final item = controller.catergories[index];
                        return DropdownMenuItem<String>(
                          value: item,
                          child: MText(
                            text: item.toUpperCase(),
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        );
                      }),
                onChanged: (value) {
                  if (value == null) return;
                  controller.catergory.value = value;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: pageTheme,
                  ),
                  onPressed: _showAddCategory,
                ),
              );
            }),
            MSpace.vertical(16),
            MInputTextField(
              controller: controller.amount,
              keyboardType: TextInputType.number,
              label: 'Amount',
            ),
            MSpace.vertical(16),
            MInputTextField(
              controller: controller.note,
              maxLines: 3,
              label: 'Note',
            ),
            MSpace.vertical(32),
            Center(
              child: MButton(
                spacing: 30,
                onPress: () async {
                  await controller.onSave();
                  Get.back();
                },
                text: 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionType({
    required bool isSelected,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: MContainer(
        color: Colors.grey.shade200,
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade400,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 30,
        ),
        child: MText(
          text: label,
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showAddCategory() async {
    final text = TextEditingController();
    final focus = FocusNode();
    focus.requestFocus();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          children: [
            MInputTextField(
              controller: text,
              label: 'Category',
              focusNode: focus,
            ),
            MSpace.vertical(30),
            MButton(
              onPress: () async {
                if (text.text.trim().isEmpty) {
                  return;
                }
                await controller.addCategory(text.text.trim());
                Get.back();
              },
              text: 'Add',
            ),
          ],
        ),
      ),
    );
    text.dispose();
    focus.dispose();
  }

  Color _getPageTheme(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.blue;
      case TransactionType.expense:
        return Colors.red;
    }
  }
}
