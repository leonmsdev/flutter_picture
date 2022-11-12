import 'package:flutter/material.dart';
import 'package:learn_dart/style/theme.dart';

class BorderButton extends StatelessWidget {
  const BorderButton(
      {super.key,
      required this.lable,
      required this.onTap,
      required this.width,
      required this.height});

  final String lable;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: appThemeData().primaryColor)),
        child: Center(
            child: Text(
          lable,
          style: const TextStyle(
            color: Colors.black,
          ),
        )),
      ),
    );
  }
}
