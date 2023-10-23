// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:money_management/old/widgets/widget_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:money_management/old/color/app_color.dart' as app_color;
import 'package:money_management/old/db/database_reminder.dart';
import 'package:money_management/old/settings/expense_category.dart';
import 'package:money_management/old/settings/income_category.dart';
import 'package:money_management/old/settings/passcode.dart';
import 'package:money_management/old/transaction/add_transaction.dart';

class Configure extends StatefulWidget {
  const Configure({Key? key}) : super(key: key);

  @override
  _ConfigureState createState() => _ConfigureState();
}

class _ConfigureState extends State<Configure> {
  final widgets = Get.put(WidgetController());

  ///set bool of passcode///
  Future<void> addBoolTrue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', true);
    debugPrint('set True');
  }

  Future<void> addBoolFalse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', false);
    debugPrint('set False');
  }

  Future<bool?>? getBoolValuesSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    final bool? boolValue = prefs.getBool('boolValue');
    return boolValue;
  }

  FlutterLocalNotificationsPlugin? appNotification;

  TimeOfDay _time = const TimeOfDay(hour: 21, minute: 00);

  String? dates = '9:00 PM';

  bool? reminder = false;
  bool finger = false;
  String passcode = '';

  final handler = Get.put(DatabaseHandlerTime());

  // DatabaseHandlerPasscode handlerPasscode = DatabaseHandlerPasscode();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().whenComplete(() async {
      finger = (await getBoolValuesSF())!;
    });

    ///notification settings///
    const androidInitilize = AndroidInitializationSettings('app_icon');
    const iOsInitilize = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidInitilize, iOS: iOsInitilize);
    appNotification = FlutterLocalNotificationsPlugin();
    appNotification!.initialize(initializationSettings,
        onDidReceiveNotificationResponse: notificationSelected);

    ///database handler///

    // dates = _time.format(context);
    // handler = DatabaseHandlerTime();
    handler.initializeDB().whenComplete(() async {
      ///take data to dates///
      dates = await handler.retrieveWithTime();

      ///take data to reminder boolean///
      reminder = await handler.retrieveWithReminder();

      debugPrint('data reached: $reminder');
      setState(() {});
    });
  }

  @Deprecated('Notification')
  Future<void> _showNotification(String dates) async {
    const androidDetails =
        AndroidNotificationDetails('Channel ID', 'Programmer');
    const iOsDetails = DarwinNotificationDetails();
    const generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOsDetails);

    Future.delayed(const Duration(seconds: 86400), () {
      _showNotification(dates);
      setState(() {});
    });
    final List<String> value = dates.split(':');
    final List<String> second = value[1].split(' ');
    int last = int.parse(value[0]);
    String valueLast = '$last';
    if (second[1] == 'PM') {
      last += 12;
      valueLast = '$last';
    } else {
      if (last == 11 || last == 12) {
        valueLast = '$last';
      } else {
        valueLast = '0$last';
      }
    }
    final String time = '$valueLast:${second[0]}';

    final DateTime now = DateTime.now();
    debugPrint('$now');
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    debugPrint(formatted);

    final String dateAndTime = '$formatted $time:00.000000';

    debugPrint('time id: $dateAndTime');

    // final DateTime reminderTime = DateTime.parse(dateAndTime);
    // appNotification!.zonedSchedule(0, 'Don`t Forget to add transactions...',
    //     'add now', reminderTime,uiLocalNotificationDateInterpretation: generalNotificationDetails);
    // int delay = 86400;

    // for (int i = 1; i <= 3; i++) {
    //   final DateTime reminderTime =
    //       DateTime.parse(dateAndTime).add(Duration(seconds: delay));
    //   debugPrint('time is: $reminderTime');

    //   final scheduledTime = reminderTime;
    //   debugPrint('$i : $scheduledTime');
    //   appNotification!.schedule(i, 'Don`t Forget to add transactions...',
    //       'add now', scheduledTime, generalNotificationDetails);
    //   delay += 86400;
    // }
  }

  @Deprecated('message')
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        if (reminder == true) {
          _showNotification(dates!);
        }
        debugPrint('$_time');
      });
      // handler = DatabaseHandlerTime();
      handler.initializeDB().whenComplete(() async {
        reminder = await handler.retrieveWithReminder();

        ///add data to reminder database///
        final TimeDb user =
            TimeDb(time: _time.format(context), reminder: '$reminder');
        final List<TimeDb> listOfTimeDb = [user];
        final DatabaseHandlerTime db = DatabaseHandlerTime();
        await db.insertReminder(listOfTimeDb);

        ///take data to dates///
        dates = await handler.retrieveWithTime();
        // await this.addUsers();
        setState(() {
          if (reminder == true) {
            _showNotification(dates!);
          }
        });
      });
    }
  }

  @Deprecated('message')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.back,
      appBar: AppBar(
        title: const Text('Configuration'),
        backgroundColor: const Color(0xFF13254C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          widgets.boxH(5),
          const Text(
            'Category',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          widgets.boxH(5),
          Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            color: app_color.widget,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const IncomeCategory()));
                  },
                  child: const Text(
                    'Income Category Settings',
                    style: TextStyle(color: app_color.text, fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExpenseCategory()));
                  },
                  child: const Text(
                    'Expenses Category Settings',
                    style: TextStyle(color: app_color.text, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          widgets.boxH(5),
          Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            color: app_color.widget,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PassCode()));
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set PassCode',
                            style:
                                TextStyle(color: app_color.text, fontSize: 16),
                          ),
                          Text(
                            'default Passcode : 0000',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      )),
                ),
                SwitchListTile(
                    title: const Text('App Lock',
                        style: TextStyle(color: app_color.text, fontSize: 16)),
                    value: finger,
                    onChanged: (bool newValue) async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('boolValue');

                      setState(() {
                        finger == false ? addBoolTrue() : addBoolFalse();
                        finger == false ? finger = true : finger = false;
                      });
                    }),
                SwitchListTile(
                  title: const Text('Set Reminder?',
                      style: TextStyle(color: app_color.text, fontSize: 16)),
                  value: reminder!,
                  onChanged: (bool newValue) async {
                    // handler = DatabaseHandlerTime();
                    handler.initializeDB().whenComplete(() async {
                      ///add data to reminder database///
                      final TimeDb user = TimeDb(
                          time: _time.format(context), reminder: '$newValue');
                      final List<TimeDb> listTimeDb = [user];
                      final DatabaseHandlerTime db = DatabaseHandlerTime();
                      await db.insertReminder(listTimeDb);

                      ///take data to dates///
                      dates = await handler.retrieveWithTime();

                      ///take data to reminder boolean///
                      reminder = await handler.retrieveWithReminder();
                      // await this.addUsers();
                      setState(() {
                        if (reminder == true) {
                          _showNotification(dates!);
                        }
                      });
                    });
                  },
                ),
                reminder == true
                    ? TextButton(
                        // color: app_color.widget,
                        onPressed: () async {
                          debugPrint('reminder');
                          _selectTime();
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Time?',
                              style: TextStyle(
                                  color: app_color.text, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              dates!,
                              style: const TextStyle(
                                  color: app_color.text, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> notificationSelected(NotificationResponse? payload) async {
    Future.delayed(const Duration(milliseconds: 0), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AddTrans()));
      setState(() {});
    });
  }
}
