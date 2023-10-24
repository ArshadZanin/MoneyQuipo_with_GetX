// Flutter imports:
import 'package:flutter/material.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Widget textHere(String text) {
    return MText(
      text: text,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      letterSpacing: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const MText(
          text: 'About us',
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xFF020925),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textHere('Developed by Arshad Sanin'),
          ],
        ),
      ),
    );
  }
}
