import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  const FilledButton(
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
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          lable,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
