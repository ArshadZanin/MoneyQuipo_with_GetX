// Flutter imports:
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/security_controller.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

// Project imports:
import 'package:money_management/old/color/app_color.dart' as app_color;

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({
    Key? key,
    required this.setPasscode,
    required this.onSuccess,
  }) : super(key: key);
  final bool setPasscode;
  final Function(String?) onSuccess;

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final controller = Get.put(SecurityController());

  @override
  void initState() {
    controller.initialize(
      widget.setPasscode,
      widget.onSuccess,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.back,
      appBar: widget.setPasscode
          ? AppBar(
              title: Obx(() {
                return MText(
                  text: controller.security.value != null
                      ? 'Enter previous passcode'
                      : controller.step.value == UserInputStep.newInput
                          ? 'Enter new passcode'
                          : 'Re-enter new passcode',
                );
              }),
            )
          : null,
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
          ShakeX(
            manualTrigger: true,
            controller: (animate) {},
            key: controller.shakeKey,
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => _buildPasscode(
                    index + 1 <= controller.userInput.value.length,
                    controller.isError.value ? Colors.red : Colors.black,
                  ),
                ),
              );
            }),
          ),
          MSpace.vertical(20),
          Obx(
            () => MText(
              text: controller.errorText.value,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          MSpace.vertical(30),
          ...List.generate(3, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (col) {
                  final number = (row * 3) + col + 1;
                  return TextButton(
                    onPressed: () => controller.addNum(
                      number,
                      widget.onSuccess,
                    ),
                    child: MText(
                      text: '$number',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MSpace.horizonital(65),
              TextButton(
                onPressed: () => controller.addNum(
                  0,
                  widget.onSuccess,
                ),
                child: const MText(
                  text: '0',
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => controller.removeNum(),
                child: const Icon(Icons.backspace),
              ),
            ],
          ),
          MSpace.vertical(30),
        ],
      ),
    );
  }

  Widget _buildPasscode(
    bool isSelected,
    Color color,
  ) {
    if (isSelected)
      return Icon(
        Icons.circle,
        color: color,
      );
    else
      return Icon(
        Icons.circle_outlined,
        color: color,
      );
  }
}
