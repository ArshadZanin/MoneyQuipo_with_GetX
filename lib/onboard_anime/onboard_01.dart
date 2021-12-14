// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'package:money_management/db/database_expense_category.dart';
import 'package:money_management/db/database_income_category.dart';
import 'package:money_management/db/database_reminder.dart';
import 'package:money_management/db/database_transaction.dart';
import 'package:money_management/onboard_anime/welcome_page.dart';
import 'package:money_management/splash%20screen/splash_screen.dart';
import 'fading_sliding_widget.dart';
import 'onboard_page.dart';
import 'onboard_page_item.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> with SingleTickerProviderStateMixin {
  DatabaseHandler handler = DatabaseHandler();
  DatabaseHandlerIncomeCategory handler1 = DatabaseHandlerIncomeCategory();
  DatabaseHandlerExpenseCategory handler2 = DatabaseHandlerExpenseCategory();

  List<OnboardPageItem> onboardPageItems = [
    OnboardPageItem(
      lottieAsset: 'assets/animations/add.json',
      text:
          'You can add income and expenses with'
              ' different accounts in different categories',
    ),
    OnboardPageItem(
      lottieAsset: 'assets/animations/calculating.json',
      text:
          'You can calculate and manage expenses'
              ' and incomes or assets and liabilities',
      animationDuration: const Duration(milliseconds: 1100),
    ),
    OnboardPageItem(
      lottieAsset: 'assets/animations/group_working.json',
      text: 'See stats of all categories in income and expenses',
    ),
  ];

  PageController? _pageController;

  List<Widget> onboardItems = [];
  double? _activeIndex;
  bool onboardPage = false;
  AnimationController? _animationController;

  @override
  void initState() {
    initializePages(); //initialize pages to be shown
    _pageController = PageController();
    _pageController!.addListener(() {
      _activeIndex = _pageController!.page;
      debugPrint('Active Index: $_activeIndex');
      if (_activeIndex! >= 0.5 && onboardPage == false) {
        setState(() {
          onboardPage = true;
        });
      } else if (_activeIndex! < 0.5) {
        setState(() {
          onboardPage = false;
        });
      }
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    super.initState();
  }

  void initializePages() {
    onboardItems.add(const WelcomePage()); // welcome page
    for (var onboardPageItem in onboardPageItems) {
      //adding onboard pages
      onboardItems.add(OnboardPage(
        onboardPageItem: onboardPageItem,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: onboardItems,
            ),
          ),
          Positioned(
            bottom: height * 0.15,
            child: SmoothPageIndicator(
              controller: _pageController!,
              count: onboardItems.length,
              effect: WormEffect(
                dotWidth: width * 0.03,
                dotHeight: width * 0.03,
                dotColor: onboardPage
                    ? const Color(0xff000000)
                    : const Color(0x566fffff),
                activeDotColor: onboardPage
                    ? const Color(0xFF9544d0)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () async {
                final User student = User(
                    trans: 'income',
                    date: 'Jan 01, 2015',
                    account: 'Assets',
                    category: 'Cash',
                    amount: '0',
                    note: 'it not affect the user');
                final User student1 = User(
                    trans: 'expense',
                    date: 'Jan 01, 2015',
                    account: 'Liabilities',
                    category: 'Food',
                    amount: '0',
                    note: 'it not affect the user');

                final List<User> listOfUser = [student, student1];
                final DatabaseHandler db = DatabaseHandler();
                await db.insertUser(listOfUser);

                final IncomeCategoryDb user1 =
                    IncomeCategoryDb(incomeCategory: 'Cash');
                final List<IncomeCategoryDb> listIncomeCategoryDb = [user1];
                final DatabaseHandlerIncomeCategory db1 =
                    DatabaseHandlerIncomeCategory();
                await db1.insertIncomeCategory(listIncomeCategoryDb);

                final ExpenseCategoryDb user2 =
                    ExpenseCategoryDb(expenseCategory: 'Food');
                final List<ExpenseCategoryDb> listExpenseCategoryDb = [user2];
                final DatabaseHandlerExpenseCategory db2 =
                    DatabaseHandlerExpenseCategory();
                await db2.insertExpenseCategory(listExpenseCategoryDb);

                Future<void> addBoolFalse() async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('boolValue', false);
                  debugPrint('set False');
                }

                addBoolFalse();
                Future<void> addStringToSF(String passcode) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('stringValue', passcode);
                }

                addStringToSF('0000');

                final TimeDb user = TimeDb(time: '9:00 PM', reminder: 'false');
                final List<TimeDb> listofTimeDb = [user];
                final DatabaseHandlerTime db0 = DatabaseHandlerTime();
                await db0.insertReminder(listofTimeDb);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const HomePageAssist();
                }));

                // Get.off(const HomePageAssist());
              },
              child: FadingSlidingWidget(
                animationController: _animationController!,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  alignment: Alignment.center,
                  width: width * 0.8,
                  height: height * 0.075,
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: onboardPage
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF220555),
                      fontSize: width * 0.05,
                      fontFamily: 'ProductSans',
                    ),
                  ),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.1),
                    ),
                    gradient: LinearGradient(
                      colors: onboardPage
                          ? [
                              const Color(0xFF8200FF),
                              const Color(0xFFFF3264),
                            ]
                          : [
                              const Color(0xFFFFFFFF),
                              const Color(0xFFFFFFFF),
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
