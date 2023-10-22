// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:money_management/old/home.dart';
import 'package:money_management/old/splash%20screen/security_passcode.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: Center(
        child: OpenContainer(
          closedBuilder: (_, openContainer) {
            return const SizedBox(
              height: 60,
              width: 220,
              child: Center(
                child: Text(
                  'MoneyQuipo',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          openColor: Colors.white,
          closedElevation: 20,
          closedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          transitionDuration: const Duration(milliseconds: 700),
          openBuilder: (_, closeContainer) {
            return const SplashScreen1Sub();
          },
        ),
      ),
    );
  }
}

class SplashScreen1Sub extends StatefulWidget {
  const SplashScreen1Sub({Key? key}) : super(key: key);

  @override
  _SplashScreen1SubState createState() => _SplashScreen1SubState();
}

class _SplashScreen1SubState extends State<SplashScreen1Sub>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  AnimationController? _controller;
  Animation<double>? animation1;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller!, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller!.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    Timer(const Duration(seconds: 4), () {
      setState(() {
        Navigator.pushReplacement(
            context, PageTransition1(const SplashScreen1SubHome()));
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: app_color.widget,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment
                .bottomRight, // 10% of the width, so there are ten blinds.
            colors: <Color>[
              Color(0xff00c9af),
              // Color(0xff11c211),
              // Color(0xff2ad054),
              Color(0xff61f680)
            ], // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: _height / _fontSize),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: _textOpacity,
                  child: Text(
                    'MoneyQuipo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: animation1!.value,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                opacity: _containerOpacity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: _width / _containerSize,
                  width: _width / _containerSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.fitHeight,
                      )),
                  // child: const Icon(Icons.money),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTransition1 extends PageRouteBuilder {
  final Widget page;

  PageTransition1(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                child: page,
                axisAlignment: 0,
              ),
            );
          },
        );
}

class SplashScreen1SubHome extends StatefulWidget {
  const SplashScreen1SubHome({Key? key}) : super(key: key);

  @override
  State<SplashScreen1SubHome> createState() => _SplashScreen1SubHomeState();
}

class _SplashScreen1SubHomeState extends State<SplashScreen1SubHome> {
  // DatabaseHandlerPasscode handler = DatabaseHandlerPasscode();

  bool? check = false;

  Future<bool?>? getBoolValuesSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    final bool? boolValue = prefs.getBool('boolValue');
    return boolValue;
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().whenComplete(() async {
      check = await getBoolValuesSF();
      debugPrint('check : $check');
      setState(() {});
    });

    // handler = DatabaseHandlerPasscode();
    // handler.initializeDB().whenComplete(() async {
    //   check = (await handler.retrieveCheck())!;
    //   debugPrint("$check");
    //   // await this.addUsers();
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: check == true ? const SecurityPasscode() : const MyHomePage(),
    );
  }
}

class HomePageAssist extends StatelessWidget {
  const HomePageAssist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Management',
      theme: ThemeData(
        fontFamily: 'Saira',
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}
