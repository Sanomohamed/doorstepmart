import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test.dart';

void main() {
  testWidgets('Sample test from test.dart', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MyApp());

    // Verify if the text field is present
    expect(find.byType(TextField), findsOneWidget);

    // Enter text into the text field
    await tester.enterText(find.byType(TextField), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
  });
}

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
