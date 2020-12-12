import 'dart:io';

import 'package:hda_driver/resources/misc/base-url.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:rxdart/rxdart.dart';

import 'identity-service.dart';

class SocketService {
  Identity identity;
  WebSocket webSocket;
  BehaviorSubject<String> subject = new BehaviorSubject<String>();

  final String url = socketHost;

  Future initialize() async {
    identity = getIt<Identity>();

    try {
      if (webSocket == null) {
        webSocket = await WebSocket.connect(
          url,
          headers: {'Authorization': 'Bearer ${identity.getToken()}'},
        );

        webSocket.listen((event) {
          subject.add(event);
          print([event, ' received socket']);
        });

        webSocket.handleError((error) {
          print(error);
        });
      }
    } catch (e) {
      print([e, 'error connecting socket']);
    }
  }

  void listen(void listener(value)) {
    print('listener attached ');
    subject.stream.listen(listener);
  }

  // void removeListener(Function listener) {
  //   if(subject.hasListener) {
  //   }
  // }

  void disconnect() {
    webSocket?.close();
  }

  emit(dynamic data) async {
    try {
      if (webSocket != null) {
        webSocket.add(data);
      } else {
        print("Socket isn't initialized yet");
      }
    } catch (e) {
      print(e);
    }
  }
}
