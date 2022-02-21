import 'dart:async';

import 'package:flutter/material.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({Key? key}) : super(key: key);

  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  StreamController streamController = StreamController<String>.broadcast();
  StreamSubscription? streamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                startStream();
              },
              child: Text('Add To Stream')),
          TextButton(
              onPressed: () {
                subscribeStream();
              },
              child: Text('Subscribe To Stream')),
          TextButton(
              onPressed: () {
                cancelSubscription();
              },
              child: Text('Cancel Subscription To Stream')),
        ],
      ),
    );
  }

  Future<void> startStream() async {
    for (int i = 0; i < 500; i++) {
      streamController.sink.add('This is $i');
      await Future.delayed(Duration(seconds: 4));
      print(i);
    }
  }

  Future<void> subscribeStream() async {
    streamSubscription = streamController.stream.listen((event) {
      print(event);
    });
  }

  Future<void> cancelSubscription() async {
    streamSubscription?.cancel();
  }
}
