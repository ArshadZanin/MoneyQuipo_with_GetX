// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/account_details_controller.dart';
import 'package:money_management/refactored/core/models/transaction.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final controller = Get.put(AccountDetailsController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        title: const MText(
          text: 'Account Details',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xff28008d),
                  Color(0xff3003a5),
                  Color(0xff6325ff)
                ],
                tileMode: TileMode.repeated,
              ),
            ),
            child: Obx(
              () => Row(
                children: [
                  accountTexts(
                    heading: 'Assets',
                    amount: controller.assets.value,
                    colorAmount: Colors.blue,
                  ),
                  accountTexts(
                    heading: 'Liabilities',
                    amount: controller.liabilities.value,
                    colorAmount: Colors.red,
                  ),
                  accountTexts(
                    heading: 'Total',
                    amount:
                        controller.assets.value - controller.liabilities.value,
                    colorAmount: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          MSpace.vertical(1),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              width: MediaQuery.of(context).size.width,
              child: Obx(() {
                return ListView.builder(
                  itemCount:
                      controller.transactionController.transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final transaction =
                        controller.transactionController.transactions[index];
                    return _buildTransactionCard(transaction);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.5),
        leading: MContainer(
          color: const Color.fromRGBO(238, 238, 238, 1),
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(10),
          child: Icon(
            Icons.attach_money,
            color: transaction.account == AccountType.asset
                ? Colors.blue
                : Colors.red,
          ),
        ),
        title: MText(
          text: '${transaction.account?.name.toUpperCase()}',
          color: Colors.black,
        ),
        subtitle: MText(
          text:
              controller.format.format(transaction.dateTime ?? DateTime.now()),
          color: Colors.black,
          fontSize: 16,
        ),
        trailing: MText(
          text: '${transaction.amount ?? 0}',
          textAlign: TextAlign.end,
          color: transaction.account == AccountType.asset
              ? Colors.blue
              : Colors.red,
        ),
      ),
    );
  }

  Widget accountTexts({
    required String heading,
    required double amount,
    required Color colorAmount,
  }) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          MText(
            text: heading,
            color: Colors.white,
          ),
          MText(
            text: '$amount',
            color: colorAmount,
          ),
        ],
      ),
    );
  }
}
