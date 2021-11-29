// Flutter imports:
import 'package:flutter/material.dart';
import 'package:money_management/widgets/widget_controller.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:money_management/color/app_color.dart' as app_color;
import 'package:money_management/home.dart';

class SecurityPasscode extends StatefulWidget {
  const SecurityPasscode({Key? key}) : super(key: key);

  @override
  _SecurityPasscodeState createState() => _SecurityPasscodeState();
}

class _SecurityPasscodeState extends State<SecurityPasscode> {
  // DatabaseHandlerPasscode handler = DatabaseHandlerPasscode();
  final widgets = Get.put(WidgetController());

  Future<bool?>? getBoolValuesSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    final bool? boolValue = prefs.getBool('boolValue');
    debugPrint('in sp value : $boolValue');
    return boolValue;
  }

  Future<String?>? getStringValuesSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    final String? stringValue = prefs.getString('stringValue');
    debugPrint('passcode in sp : $stringValue');
    return stringValue;
  }

  int count = 0;
  String passcode = '';
  bool check = false;
  String passcodeFromDb = '';

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().whenComplete(() async {
      check = (await getBoolValuesSF())!;
    });
    SharedPreferences.getInstance().whenComplete(() async {
      passcodeFromDb = (await getStringValuesSF())!;
      debugPrint(passcode);
    });
    if (mounted) {
      // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (mounted) {
      // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
  }

  void inputNum(String num){
    if (count != 4) {
      if (passcode.length != 4) {
        passcode = passcode + num;
      }
      setState(() {
        count++;
      });
    }
  }

  @Deprecated('message')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.back,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Passcode',
            style: TextStyle(color: app_color.text, fontSize: 33),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              count >= 1
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
              const SizedBox(
                width: 5,
              ),
              count >= 2
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
              const SizedBox(
                width: 5,
              ),
              count >= 3
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
              const SizedBox(
                width: 5,
              ),
              count >= 4
                  ? const Icon(Icons.circle)
                  : const Icon(Icons.circle_outlined),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('1', (){
                inputNum('1');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('2', (){
                inputNum('2');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('3', (){
                inputNum('3');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('4', (){
                inputNum('4');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('5', (){
                inputNum('5');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('6', (){
                inputNum('6');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('7', (){
                inputNum('7');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('8', (){
                inputNum('8');
              }),
              widgets.boxW(5),
              widgets.passcodeButton('9', (){
                inputNum('9');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widgets.passcodeButton('Ok', (){
                if (passcode.length == 4) {
                  debugPrint('$passcode  $passcodeFromDb');
                  if (passcode == passcodeFromDb) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyHomePage()));
                  } else {
                    setState(() {
                      passcode = '';
                      count = 0;
                    });
                  }
                }
              }),
              widgets.boxW(5),
              widgets.passcodeButton('0', (){
                inputNum('0');
              }),
              widgets.boxW(5),
              FlatButton(
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
