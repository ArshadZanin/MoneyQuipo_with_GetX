import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/constants/app_colors.dart';
import 'package:money_management/refactored/controllers/transaction_controller.dart';
import 'package:money_management/refactored/models/transaction.dart';
import 'package:money_management/refactored/screens/add_transaction_screen.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final controller = Get.put(TransactionController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.fetchTransactions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              title: Row(
                children: [
                  const MText(
                    text: 'Money Quipo.',
                    color: AppColor.tertiary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTransactionScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.post_add_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              expandedHeight: 292.0,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    background: Container(
                      color: Colors.white,
                      child: Obx(() {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MSpace.vertical(80),
                            Row(
                              children: [
                                MSpace.horizonital(16),
                                _buildAmountCard(
                                  context: context,
                                  shadowColor: AppColor.shadowGreen,
                                  mainColor1: AppColor.greenBox1,
                                  mainColor2: AppColor.greenBox2,
                                  heading: 'Earned',
                                  value: '${controller.income.value}',
                                  name: 'income',
                                ),
                                MSpace.horizonital(16),
                                _buildAmountCard(
                                  context: context,
                                  shadowColor: AppColor.shadowRed,
                                  mainColor1: AppColor.redBox1,
                                  mainColor2: AppColor.redBox2,
                                  heading: 'Spent',
                                  value: '${controller.expense.value}',
                                  name: 'expense',
                                ),
                                MSpace.horizonital(16),
                              ],
                            ),
                            MSpace.vertical(16),
                            _buildBalanceCard(
                              expense: controller.expense.value,
                              income: controller.income.value,
                            ),
                            MSpace.vertical(8),
                            const MText(
                              text: 'Transactions',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              return SliverList(
                delegate: SliverChildListDelegate([
                  if (controller.transactions.isEmpty)
                    const MContainer(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: MText(
                        text: 'No transactions available.',
                      ),
                    ),
                  ...List.generate(controller.transactions.length, (index) {
                    return _buildTransactionItem(
                      controller.transactions[index],
                    );
                  }),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard({
    required BuildContext context,
    required Color shadowColor,
    required Color mainColor1,
    required Color mainColor2,
    required String heading,
    required String value,
    required String name,
  }) {
    return Expanded(
      child: Material(
        elevation: 10,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(10),
        child: MContainer(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[mainColor1, mainColor2],
            tileMode: TileMode.repeated,
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  text: heading,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                MText(
                  text: value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                MText(
                  text: '$name this month',
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard({
    required double income,
    required double expense,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 5,
        shadowColor: const Color(0xff4792ff),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Column(
          children: [
            const MText(
              text: 'Budget so far',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2000,
                  percent: percentBar(income, expense),
                  center: income - expense < 0
                      ? Text(
                          '${income - expense}',
                          style: const TextStyle(
                            color: Color(0xffb10000),
                            letterSpacing: 1,
                          ),
                        )
                      : Text(
                          '${income - expense}',
                          style: const TextStyle(
                            color: Color(0xFFffffff),
                            letterSpacing: 1,
                          ),
                        ),
                  // linearStrokeCap: LinearStrokeCap.roundAll,
                  barRadius: const Radius.circular(30),
                  progressColor: expense <= income
                      ? Colors.lightBlueAccent
                      : Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(
          Icons.attach_money,
          color: transaction.transactionType == TransactionType.income
              ? Colors.green
              : Colors.red,
        ),
      ),
      title: Text(
        transaction.account?.name ?? '',
      ),
      subtitle: Text(
        'Category: ${transaction.transactionType?.name}',
      ),
      trailing: Text(
        '${transaction.amount ?? ''}',
      ),
    );
  }

  double percentBar(double income, double expense) {
    if (expense < income) {
      double value1 = (expense / income) - 1;
      if (value1 < 0) {
        value1 = value1 * -1;
      }
      return value1;
    } else if (expense > income) {
      double value2 = 1 - (income / expense);
      if (value2 < 0) {
        value2 = value2 * -1;
      }
      return value2;
    } else {
      return 0.0;
    }
  }
}
