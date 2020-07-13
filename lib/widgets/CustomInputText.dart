import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputText extends StatelessWidget {

  final TextEditingController controller;
  final Color cor;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final double borderRadius;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final Function(String) validator;
  final List<TextInputFormatter> inputFormatters;

  const CustomInputText({
    this.controller,
    this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.borderRadius = 40,
    this.obscureText = false, 
    this.cor,
    this.onSaved,
    this.validator,
    this.inputFormatters, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: this.onChanged,
      onSaved: this.onSaved,
      validator: this.validator,
      inputFormatters: this.inputFormatters,
      controller: this.controller,
      obscureText: this.obscureText,
      keyboardType: this.keyboardType,
      maxLines: this.maxLines,
      decoration: InputDecoration(
        hoverColor: this.cor,
        labelText: this.label,
        hintText: this.hint,
        labelStyle: TextStyle(
          color: this.cor,
        ),
        contentPadding: EdgeInsets.only(
          top: 16,
          bottom: 16,
          right: 16,
          left: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(this.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(this.borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: this.cor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(this.borderRadius),
          borderSide: BorderSide(
            width: 2,
            color: this.cor,
          ),
        ),
      ),
    );
  }
}
