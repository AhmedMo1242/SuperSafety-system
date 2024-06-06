import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Color backcolor_;
  final Color textcolor_;
  final String text_;



  const MyButton({super.key, required this.onTap, required this.backcolor_, required this.textcolor_ , required this.text_});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: backcolor_,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text_,
            style: TextStyle(
              color: textcolor_,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ),
      ),
    );
  }
}


