// Flutter imports:
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// Project imports:
import 'package:money_management/old/color/app_color.dart' as app_color;
import 'package:money_management/old/db/database_expense_category.dart';
import 'package:money_management/old/db/database_income_category.dart';
import 'package:money_management/old/db/database_transaction.dart';
import 'package:money_management/old/onboard_anime/onboard_01.dart';
import 'package:money_management/old/settings/configure.dart';
import 'package:money_management/old/settings/about.dart';
import 'package:money_management/old/splash%20screen/splash_screen.dart';
import 'package:money_management/old/widgets/widget_controller.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final widgets = Get.put(WidgetController());
  final handler = Get.put(DatabaseHandler());
  final handler1 = Get.put(DatabaseHandlerIncomeCategory());
  final handler2 = Get.put(DatabaseHandlerExpenseCategory());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.back,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SplashScreen1Sub()));
            },
          )
        ],
        elevation: 0.2,
        backgroundColor: app_color.widget,
        title: const Text('Settings'),
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          children: [
            widgets.settingIcon(
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Configure()));
                },
                icon: Icons.settings_outlined,
                name: 'Configuration'),
            widgets.settingIcon(
                onPress: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content:
                          const Text('it will delete permanently all data....'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            handler.deleteDb();
                            handler1.deleteDb();
                            handler2.deleteDb();

                            Navigator.pop(context, 'OK');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Onboard()));
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icons.settings_backup_restore,
                name: 'Reset App'),
            widgets.settingIcon(
                onPress: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Help()));
                },
                icon: Icons.info_outline,
                name: 'About Us'),
          ]),
    );
  }
}
