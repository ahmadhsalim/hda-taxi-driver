import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hda_driver/models/chat-message.dart';
import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:hda_driver/widgets/incoming-message.dart';
import 'package:hda_driver/widgets/outgoing-message.dart';
import 'package:hda_driver/widgets/profile-photo.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Customer customer;
  final Trip trip;
  final File customerPhoto;
  ChatPage({Key key, this.trip, this.customer, this.customerPhoto})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Identity identity = getIt<Identity>();
  TextEditingController messageController;
  List<ChatMessage> messages = [];
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  InputDecoration _buildInputDecoration({String prefixText}) {
    Color color = Colors.white;
    Color borderColor = Color(0xFFEFEFF4);
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: 1,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide:
          BorderSide(color: borderColor, width: 1, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    return InputDecoration(
        prefixText: prefixText,
        filled: true,
        fillColor: color,
        hintText: 'Message',
        hintStyle: TextStyle(color: Color(0xFF9A9A9A)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8));
  }

  void sendMessage() {
    ChatMessage message = ChatMessage(
        message: messageController.text,
        tripId: widget.trip.id,
        customerId: widget.customer.id,
        senderType: 'customer',
        createdAt: DateTime.now());
    setState(() {
      messages.add(message);
    });
    messageController.clear();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Widget empty() {
    return Center(
      child: SizedBox(
          width: 157,
          child: Text(
            'Please do not text and driver.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          )),
    );
  }

  String getDateString() {
    String date;
    DateTime day = messages[0].createdAt;

    if (DateFormat('ddMMyyyy').format(day) ==
        DateFormat('ddMMyyyy').format(DateTime.now())) {
      date = 'Today';
    } else if (DateFormat('ddMMyyyy').format(day) ==
        DateFormat('ddMMyyyy')
            .format(DateTime.now().subtract(Duration(days: 1)))) {
      date = 'Yesterday';
    } else {
      date = DateFormat('dd/MM/yyyy').format(day);
    }
    return date + ' at ' + DateFormat('KK:mm a').format(day);
  }

  Widget messageList() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          alignment: Alignment.center,
          child: Text(
            getDateString(),
            style: TextStyle(
                color: Color(0xFF9B9B9B),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ),
        ...messages
            .map((e) => e.senderType == 'customer'
                ? OutgoingMessage(e)
                : IncomingMessage(e))
            .toList(),
      ]),
    );
  }

  Widget getMessages() {
    return messages.length == 0 ? empty() : messageList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            title: Text(
              widget.customer.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF262628),
              ),
            ),
            actions: [
              ProfilePhoto(widget.customerPhoto),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child:
                    Container(color: Color(0xFFF7F7F7), child: getMessages()),
              ),
              Container(
                color: Color(0xFFcfd0ea),
                padding: const EdgeInsets.only(
                    left: 16, right: 10, top: 19, bottom: 19),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: TextStyle(
                            fontSize: 14,
                            // height: 2.0,
                            color: Color(0xFF1B1B1B)),
                        controller: messageController,
                        decoration: _buildInputDecoration(),
                      ),
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: messageController.text == null ||
                              messageController.text == ""
                          ? null
                          : sendMessage,
                      disabledColor: Colors.white,
                      color: Color(0xFF3F44AB),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
