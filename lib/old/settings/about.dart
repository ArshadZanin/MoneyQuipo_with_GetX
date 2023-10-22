// Flutter imports:
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  Widget textHere(String text){
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'About us',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF020925),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textHere('Developed by Arshad Sanin'),
            textHere('Supported by Crossroads Academy'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textHere('join our team: '),
                InkWell(
                  child: textHere('spsonline.in'),
                  onTap: () async {
                    const url = 'https://spsonline.in/';
                    if (await canLaunch(url)) {
                      await launch(
                                url,
                                forceSafariVC: false,
                              );
                        }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
