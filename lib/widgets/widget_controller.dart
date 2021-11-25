import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/color/app_color.dart' as app_color;
import 'package:syncfusion_flutter_charts/charts.dart';


class WidgetController extends GetxController{

  Widget boxH(double value){
    return SizedBox(
      height: value,
    );
  }

  Widget boxW(double value){
    return SizedBox(
      width: value,
    );
  }

  Widget earnedSpentWidget({
    required BuildContext context,
    required Color shadowColor,
    required Color mainColor1,
    required Color mainColor2,
    required String heading,
    required String value,
    required String name,
  }){
    return Expanded(
      flex: 1,
      child: Material(
        elevation: 10,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: MediaQuery.of(context).size.width / 3.2,
          height: MediaQuery.of(context).size.height / 9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: app_color.widget,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment
                  .bottomRight,
              colors: <Color>[
                mainColor1,
                // Color(0xff11c211),
                // Color(0xff2ad054),
                mainColor2
              ], // red to yellow
              tileMode: TileMode
                  .repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                    color: app_color.textWhite,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFffffff),
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '$name this month',
                  style: const TextStyle(
                    color: app_color.textWhite,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget amountTextWidget(String amount,Color textColor){
    return Text(
      amount,
      textAlign: TextAlign.end,
      style: TextStyle(
          color: textColor,
          fontSize: 18),
    );
  }

  Widget accountTexts({
    required String heading,
    required double amount,
    required Color colorAmount
  }){
    return Expanded(
        flex: 1,
        child: Column(
          children: [
            Text(
              heading,
              style: const TextStyle(
                  color: app_color.textWhite,
              ),
            ),
            Text(
              '$amount',
              style: TextStyle(
                  color: colorAmount,
              ),
            ),
          ],
        ),
    );
  }

  Widget statsHeading({required String head}){
    return Text(
      '$head Stats by category',
      style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
  }

  Widget settingIcon({
    required Function() onPress,
    required IconData icon,
    required String name
  }){
    return Column(
      children: [
        boxH(20),
        IconButton(
          onPressed: onPress,
          icon: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        Center(
            child: Text(
              name,
              style: const TextStyle(color: Colors.black),
            )),
      ],
    );
  }

  Widget passcodeButton(String num, Function() onPress){
    return FlatButton(
        onPressed: onPress,
        child: Text(
          num,
          style: const TextStyle(color: app_color.text, fontSize: 33),
        ),
    );
  }

  Widget submitButton(Function() onPress){
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      color: Colors.red,
      padding: const EdgeInsets.only(
          top: 10, bottom: 10, right: 50, left: 50),
      onPressed: onPress,
      child: const Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
    );
  }


}