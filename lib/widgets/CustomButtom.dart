import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final Color cor;
  final double width;
  final double height;
  final Function onTap;

  const CustomButtom({
    this.text,
    this.cor,
    this.width,
    this.height = 50,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
          color: this.cor,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          this.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
