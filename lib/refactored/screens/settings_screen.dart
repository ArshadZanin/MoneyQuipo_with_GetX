import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/constants/app_colors.dart';
import 'package:money_management/refactored/core/controllers/setting_controller.dart';
import 'package:money_management/refactored/core/models/transaction.dart';
import 'package:money_management/refactored/screens/catergory_configure_screen.dart';
import 'package:money_management/refactored/screens/security_screen.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final controller = Get.put(SettingsController());
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Colors.white,
        title: const MText(
          text: 'Settings',
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        children: [
          MSpace.vertical(8),
          Card(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(TransactionType.values.length, (index) {
                final type = TransactionType.values[index];
                return ListTile(
                  onTap: () {
                    Get.to(
                      () => CategoryConfigureScreen(
                        transactionType: type,
                      ),
                    );
                  },
                  title: MText(
                    text: '${type.name.capitalizeFirst} Catergory',
                    color: AppColor.tertiary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                );
              }),
            ),
          ),
          MSpace.vertical(8),
          Obx(() {
            return Card(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const MText(
                      text: 'App Lock',
                      color: AppColor.tertiary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    value: controller.appLock.value,
                    onChanged: (bool newValue) async {
                      if (newValue) {
                        Get.to(
                          () => SecurityScreen(
                            setPasscode: true,
                            onSuccess: (passcode) {
                              Get.back();
                              controller.pref
                                  .updateSecurity(security: passcode);
                              controller.appLock.value = newValue;
                            },
                          ),
                        );
                      } else {
                        Get.to(
                          () => SecurityScreen(
                            setPasscode: false,
                            onSuccess: (passcode) async {
                              Get.back();
                              controller.pref.updateSecurity();
                              controller.appLock.value = newValue;
                            },
                          ),
                        );
                      }
                    },
                  ),
                  if (controller.appLock.value)
                    ListTile(
                      onTap: () {
                        Get.to(
                          () => SecurityScreen(
                            setPasscode: true,
                            onSuccess: (passcode) async {
                              Get.back();
                              controller.pref.updateSecurity(
                                security: passcode,
                              );
                            },
                          ),
                        );
                      },
                      title: const MText(
                        text: 'Change passcode',
                        color: AppColor.tertiary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            );
          }),
          MSpace.vertical(8),
          Obx(() {
            return Card(
              color: Colors.white,
              child: SwitchListTile(
                title: const MText(
                  text: 'Set Reminder',
                  color: AppColor.tertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                value: controller.setReminder.value,
                onChanged: (bool newValue) async {
                  controller.setReminder.value = newValue;
                },
              ),
            );
          }),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.refresh_outlined),
            title: const MText(text: 'Reset app'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.info_outline_rounded),
            title: const MText(text: 'About us'),
          ),
        ],
      ),
    );
  }
}
