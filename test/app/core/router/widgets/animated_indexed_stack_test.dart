import 'package:flutly_store/app/core/router/lib/widgets/animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('renders the selected index', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AnimatedIndexedStack(
          index: 1,
          children: [
            Text('first'),
            Text('second'),
          ],
        ),
      ),
    );

    final stack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(stack.index, 1);
  });
}
