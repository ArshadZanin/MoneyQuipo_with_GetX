import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/constants/app_colors.dart';
import 'package:money_management/refactored/core/controllers/transaction_controller.dart';
import 'package:money_management/refactored/core/models/transaction.dart';
import 'package:money_management/refactored/screens/add_transaction_screen.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

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
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: AppColor.greenBox1,
          onRefresh: () async {
            await controller.fetchTransactions();
          },
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
                        Get.to(() => AddTransactionScreen());
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
                        index,
                      );
                    }),
                  ]),
                );
              }),
            ],
          ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                text: '$name totally',
                color: Colors.white,
                letterSpacing: 1,
              ),
            ],
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
        shadowColor:
            income - expense < 0 ? AppColor.redBox1 : AppColor.greenBox1,
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
                  center: MText(
                    text: '${income - expense}',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  barRadius: const Radius.circular(10),
                  progressColor: expense <= income
                      ? Colors.lightBlueAccent.shade700
                      : Colors.redAccent.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction,int index) {
    return Builder(builder: (context) {
      return Card(
        elevation: 1,
        child: ListTile(
          onLongPress: () => _showMenu(
            context,
            transaction,
            index,
          ),
          leading: MContainer(
            color: const Color.fromRGBO(238, 238, 238, 1),
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.attach_money,
              color: transaction.transactionType == TransactionType.income
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MText(
                text: _transTitle(transaction),
                fontSize: 18,
                color: Colors.black,
              ),
              MText(
                text: '${transaction.account?.name.toUpperCase()}',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              MText(
                text: controller.format.format(
                  transaction.dateTime ?? DateTime.now(),
                ),
                fontSize: 14,
                color: Colors.black,
              ),
            ],
          ),
          trailing: MText(
            text: '${transaction.amount}',
            fontSize: 16,
            color: transaction.transactionType == TransactionType.income
                ? Colors.green
                : Colors.red,
          ),
        ),
      );
    });
  }

  void _showMenu(
    BuildContext context,
    Transaction transaction,
    int index,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position =
        button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height,
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () {
            Get.to(
              () => AddTransactionScreen(
                transaction: transaction,
              ),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          onTap: () => controller.deleteTransaction(
            transaction.id ?? 0,
            index,
          ),
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
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

  String _transTitle(Transaction trans) {
    return trans.transactionType == TransactionType.income
        ? 'Recieved from ${trans.category}'
        : 'Paid for ${trans.category}';
  }
}
