import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mobilepay/flutter_mobilepay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isInstalled = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool isInstalled;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await FlutterMobilepay.setup("APPFI0000000000");
      platformVersion = await FlutterMobilepay.platformVersion;
      isInstalled = await FlutterMobilepay.isMobilePayInstalled;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _isInstalled = isInstalled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('IsInstalled: $_isInstalled\n'),
              RaisedButton(
                onPressed: () async {
                  print("onPressed");
                  var result = await FlutterMobilepay.payment("1", 101);
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      children: [
                        Text(result)
                      ],
                    );
                  });
                },
                child: Text("Payment"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
