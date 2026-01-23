import 'package:flutly_store/app/core/router/lib/widgets/animated_indexed_stack.dart';
import 'package:flutly_store/app/core/router/lib/widgets/indexed_stacked_route_branch_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('builds AnimatedIndexedStack with current index', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const IndexedStackedRouteBranchContainer(
          currentIndex: 1,
          children: [
            SizedBox(key: Key('first')),
            SizedBox(key: Key('second')),
          ],
        ),
      ),
    );

    final stack = tester.widget<AnimatedIndexedStack>(
      find.byType(AnimatedIndexedStack),
    );
    expect(stack.index, 1);
    expect(stack.children.length, 2);
  });
}
