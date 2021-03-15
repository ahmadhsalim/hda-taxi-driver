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
        child: TextButton(
          onPressed: disabled ? null : onPressed,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(small ? 6 : 16),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(small ? 5 : 13),
              ),
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              filled
                  ? Colors.white.withOpacity(0.12)
                  : Colors.grey.withOpacity(0.12),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled))
                  return filled ? disabledColor : Colors.transparent;
                return filled ? color : Colors.transparent;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade600;
              } else {
                return textColor == null
                    ? filled
                        ? Colors.white
                        : Colors.black
                    : textColor;
              }
            }),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontWeight: fontWeight, fontSize: 16),
            ),
          ),
          child: Text(text),
        ));
  }
}
