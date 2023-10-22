// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:money_management/old/widgets/widget_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:money_management/old/color/app_color.dart' as app_color;
import 'package:money_management/old/settings/configure.dart';

class PassCode extends StatefulWidget {
  const PassCode({Key? key}) : super(key: key);

  @override
  _PassCodeState createState() => _PassCodeState();
}

class _PassCodeState extends State<PassCode> {
  final widgets = Get.put(WidgetController());

  ///set passcode to sp///
  Future<void> addStringToSF(String passcode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', passcode);
  }

  Future<String?>? getStringValuesSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    final String? stringValue = prefs.getString('stringValue');
    return stringValue;
  }

  // DatabaseHandlerPasscode handler = DatabaseHandlerPasscode();

  int count = 0;
  String passcode = '';
  bool check = false;
  String title = 'Set Passcode';
  String confirmPasscode = '1111';

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().whenComplete(() async {
      passcode = (await getStringValuesSF())!;
      debugPrint(passcode);
      passcode = '';
    });
  }

  void inputNum(String num) {
    if (count != 4) {
      if (passcode.length != 4) {
        passcode = passcode + num;
      }
      setState(() {
        count++;
      });
    }
  }

  @override
  @Deprecated('message')
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.back,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: app_color.button,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Passcode',
            style: TextStyle(color: app_color.text, fontSize: 33),
          ),
          widgets.boxH(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              count >= 1
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
              widgets.boxW(5),
              count >= 2
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
              widgets.boxW(5),
              count >= 3
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
              widgets.boxW(5),
              count >= 4
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
            ],
          ),
          widgets.boxH(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('1', () {
                inputNum('1');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('2', () {
                inputNum('2');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('3', () {
                inputNum('3');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('4', () {
                inputNum('4');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('5', () {
                inputNum('5');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('6', () {
                inputNum('6');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('7', () {
                inputNum('7');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('8', () {
                inputNum('8');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('9', () {
                inputNum('9');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('Ok', () {
                if (title == 'Confirm Passcode') {
                  if (passcode.length == 4) {
                    if (confirmPasscode == passcode) {
                      addStringToSF(passcode);

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const Configure()));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const PassCode()));
                    }
                  }
                } else {
                  setState(() {
                    title = 'Confirm Passcode';
                    count = 0;
                    confirmPasscode = passcode;
                    passcode = '';
                  });
                }
              }),
              widgets.boxW(5),
              widgets.passcodeButton('0', () {
                inputNum('0');
              }),
              widgets.boxW(5),
              TextButton(
                onPressed: () {
                  if (count != 0) {
                    setState(() {
                      passcode = passcode.substring(0, passcode.length - 1);
                      debugPrint(passcode);
                      count--;
                    });
                  }
                },
                child: const Icon(Icons.backspace),
              ),
            ],
          ),
          widgets.boxH(30),
        ],
      ),
    );
  }
}
