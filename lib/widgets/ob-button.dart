import 'package:flutter/material.dart';
import 'package:hda_driver/styles/MainTheme.dart';

class ObButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool disabled;
  final FontWeight fontWeight;

  ObButton({
    this.onPressed,
    this.text,
    this.color = MainTheme.primaryColour,
    this.disabled = false,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 56,
        child: FlatButton(
          onPressed: disabled ? null : onPressed,
          disabledColor: color,
          child: Text(
            text,
            style: TextStyle(fontWeight: fontWeight, fontSize: 14),
          ),
          color: color,
          textColor: Colors.black,
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ));
  }
}
