import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String prefixText;
  final bool obscureText;
  final Function onChanged;

  TextInput({
    this.label,
    this.validator,
    this.controller,
    this.prefixText,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color color = Color(0xFFF2F2F7);
    const Color errorColor = Color(0xFFFF3C3C);
    const OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)));

    const OutlineInputBorder errorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 28, child: Text(label, style: TextStyle(fontSize: 16))),
      SizedBox(
        height: 48,
        child: TextFormField(
          decoration: InputDecoration(
            prefixText: prefixText,
            filled: true,
            fillColor: color,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: errorBorder,
          ),
          obscureText: obscureText,
          validator: validator,
          controller: controller,
          onChanged: onChanged,
        ),
      ),
    ]);
  }
}
