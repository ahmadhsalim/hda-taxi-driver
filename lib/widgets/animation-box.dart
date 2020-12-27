import 'package:flutter/material.dart';

class AnimationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 183,
      width: 183,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFE4E4E4),
        borderRadius: BorderRadius.all(Radius.circular(23)),
      ),
      child: SizedBox(
        width: 84,
        child: Text(
          'Space for an animation',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFC2C2C2), fontSize: 16),
        ),
      ),
    );
  }
}
