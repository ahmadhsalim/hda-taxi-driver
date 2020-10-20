import 'package:flutter/material.dart';
import 'package:hda_app/styles/MainTheme.dart';

class ObButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;

  ObButton({this.onPressed, this.text, this.color = MainTheme.primaryColour});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 56,
        child: FlatButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
