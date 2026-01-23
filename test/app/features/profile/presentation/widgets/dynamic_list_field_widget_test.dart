import 'package:flutly_store/app/features/profile/presentation/widgets/dynamic_list_field_widget.dart';
import 'package:flutly_store/app/shared/widgets/inputs/app_reactive_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  Future<void> pumpWidget(
    WidgetTester tester, {
    required FormArray<String> formArray,
    String? label,
    String? hintText,
  }) {
    return TestUtils.pumpApp(
      tester,
      child: Material(
        child: DynamicListFieldWidget(
          label: label,
          hintText: hintText,
          formArray: formArray,
        ),
      ),
    );
  }

  testWidgets('renders label and empty hint when no items', (tester) async {
    final formArray = FormArray<String>([]);

    await pumpWidget(
      tester,
      formArray: formArray,
      label: 'Steps',
      hintText: 'No steps yet',
    );
    await tester.pumpAndSettle();

    expect(find.text('Steps'), findsOneWidget);
    expect(find.text('No steps yet'), findsOneWidget);
    expect(find.byType(AppReactiveTextFieldWidget), findsNothing);
  });

  testWidgets('adds and removes items and toggles empty hint', (tester) async {
    final formArray = FormArray<String>([]);

    await pumpWidget(
      tester,
      formArray: formArray,
      hintText: 'No steps yet',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Step'));
    await tester.pumpAndSettle();

    expect(formArray.controls, hasLength(1));
    expect(find.byType(AppReactiveTextFieldWidget), findsOneWidget);
    expect(find.text('Describe step 1'), findsOneWidget);
    expect(find.text('No steps yet'), findsNothing);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(formArray.controls, isEmpty);
    expect(find.byType(AppReactiveTextFieldWidget), findsNothing);
    expect(find.text('No steps yet'), findsOneWidget);
  });

  testWidgets('reorders items via onReorder callback', (tester) async {
    final formArray = FormArray<String>([
      FormControl<String>(value: 'First'),
      FormControl<String>(value: 'Second'),
    ]);

    await pumpWidget(tester, formArray: formArray);
    await tester.pumpAndSettle();

    final listView =
        tester.widget<ReorderableListView>(find.byType(ReorderableListView));
    listView.onReorder(0, 2);
    await tester.pumpAndSettle();

    expect(formArray.controls.first.value, 'Second');
    expect(formArray.controls.last.value, 'First');
  });
}
