import 'package:flutter/material.dart';
import 'package:money_management/refactored/screens/account_details_screen.dart';
import 'package:money_management/refactored/screens/analytics_screen.dart';
import 'package:money_management/refactored/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: controller,
        children: [
          TransactionScreen(),
          const AccountDetailsScreen(),
          const AnalyticsScreen(),
          // Settings(),
          Scaffold(
            backgroundColor: Colors.purple,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Material(
          elevation: 5,
          child: TabBar(
            controller: controller,
            indicatorWeight: 2.0,
            labelColor: Colors.red,
            unselectedLabelStyle: const TextStyle(backgroundColor: Colors.red),
            unselectedLabelColor: Colors.grey,
            indicatorPadding: const EdgeInsets.all(5.0),
            indicatorColor: const Color(0xFFFCC3C3),
            tabs: const [
              Tab(
                icon: Icon(Icons.compare_arrows),
              ),
              Tab(
                icon: Icon(Icons.book_outlined),
              ),
              Tab(
                iconMargin: EdgeInsets.only(right: 0.0),
                icon: Icon(Icons.bar_chart_outlined),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
