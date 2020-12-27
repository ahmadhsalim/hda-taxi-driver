import 'package:flutter/material.dart';
import 'package:hda_driver/styles/MainTheme.dart';

class ObButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool filled;
  final Color textColor;
  final Color disabledColor;
  final bool disabled;
  final bool small;
  final FontWeight fontWeight;

  ObButton({
    this.onPressed,
    this.text,
    this.color = MainTheme.primaryColour,
    this.textColor,
    this.disabled = false,
    this.filled = true,
    this.small = false,
    this.disabledColor = const Color(0xFFE9E9EB),
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: small ? 36 : 56,
        child: FlatButton(
          onPressed: disabled ? null : onPressed,
          disabledColor: filled ? disabledColor : Colors.transparent,
          child: Text(
            text,
            style: TextStyle(fontWeight: fontWeight, fontSize: 16),
          ),
          color: filled ? color : Colors.transparent,
          textColor: textColor == null
              ? filled
                  ? Colors.white
                  : Colors.black
              : textColor,
          disabledTextColor: filled ? Colors.black : Colors.grey.shade600,
          padding: EdgeInsets.all(small ? 6 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(small ? 5 : 13),
          ),
        ));
  }
}
