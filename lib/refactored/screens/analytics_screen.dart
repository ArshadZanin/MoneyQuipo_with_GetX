import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/refactored/core/constants/app_colors.dart';
import 'package:money_management/refactored/core/controllers/analytics_controller.dart';
import 'package:money_management/refactored/core/enums/filter.dart';
import 'package:money_management/refactored/core/models/transaction.dart';
import 'package:money_management/refactored/widgets/button/m_button.dart';
import 'package:money_management/refactored/widgets/input/m_input_dropdown_field.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final controller = Get.put(AnalyticsController());
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        title: Obx(() {
          return MText(
            text: _getTitle(controller.filter.value),
            color: Colors.black,
            fontSize: 18,
          );
        }),
        actions: [
          Center(
            child: SizedBox(
              width: 130,
              child: MInputDropdownField<Filter>(
                borderColor: Colors.black,
                value: controller.filter.value,
                items: List.generate(
                  Filter.values.length,
                  (index) {
                    final filter = Filter.values[index];
                    return DropdownMenuItem(
                      value: filter,
                      child: MText(
                        text: filter.name.toUpperCase(),
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                onChanged: (value) {
                  if (value == null) return;
                  controller.filter.value = value;
                  controller.convertToPieData();
                },
              ),
            ),
          ),
          MSpace.horizonital(5),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                TransactionType.values.length,
                (index) {
                  final type = TransactionType.values[index];
                  return MButton(
                    onPress: () {
                      controller.transactionType.value = type;
                      controller.convertToPieData();
                    },
                    spacing: 30,
                    backgroundColor: type == controller.transactionType.value
                        ? AppColor.blueButton
                        : Colors.white,
                    overlayColor: type != controller.transactionType.value
                        ? AppColor.blueButton
                        : Colors.white,
                    text: type.name.toUpperCase(),
                  );
                },
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              return Center(
                child: controller.datas.isNotEmpty
                    ? SfCircularChart(
                        legend: const Legend(
                          isVisible: true,
                          backgroundColor: Colors.white,
                        ),
                        series: <PieSeries<PieData, String>>[
                            PieSeries<PieData, String>(
                              explode: true,
                              explodeIndex: 0,
                              dataSource: controller.datas,
                              xValueMapper: (PieData data, _) => data.xData,
                              yValueMapper: (PieData data, _) => data.yData,
                              dataLabelMapper: (PieData data, _) =>
                                  '${data.yData}',
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                              ),
                            ),
                          ])
                    : const Center(
                        child: MText(
                          text: 'No data available!!',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getTitle(Filter filter) {
    switch (filter) {
      case Filter.total:
        return 'Total';
      case Filter.annually:
        return DateFormat('yyyy').format(DateTime.now());
      case Filter.monthly:
        return DateFormat('MMMM').format(DateTime.now());
      case Filter.today:
        return DateFormat('dd - MMM - yyyy').format(DateTime.now());
    }
  }
}
