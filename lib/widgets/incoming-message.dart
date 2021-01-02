import 'package:flutter/material.dart';
import 'package:hda_driver/models/chat-message.dart';
import 'package:hda_driver/widgets/triangle-shape.dart';

class IncomingMessage extends StatelessWidget {
  final ChatMessage message;
  final Color fillColor = Color(0xFFEFEFF4);

  IncomingMessage(this.message);

  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.only(
                      topLeft: radius, topRight: radius, bottomRight: radius),
                ),
                child: RichText(
                  textAlign: TextAlign.left,
                  softWrap: true,
                  text: TextSpan(children: [
                    TextSpan(
                      text: message.message,
                      style: TextStyle(color: Color(0xFF1B1B1B), fontSize: 14),
                    )
                  ]),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, bottom: 8),
                child: CustomPaint(
                  size: Size(14, 11),
                  painter: TriangleShape(fillColor, true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
