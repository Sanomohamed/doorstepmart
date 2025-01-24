import 'package:flutter/material.dart';

// Dummy widget for testing
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Test App')),
        body: TextField(),
      ),
    );
  }
}
