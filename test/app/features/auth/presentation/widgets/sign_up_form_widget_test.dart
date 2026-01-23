import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutly_store/app/features/auth/presentation/widgets/sign_up_form_widget.dart';
import 'package:flutly_store/app/features/auth/utils/auth_utils.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutly_store/app/shared/widgets/inputs/app_reactive_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../utils/test_utils.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late AuthCubit mockAuthCubit;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    mockAuthCubit = MockAuthCubit();

    when(() => mockAuthCubit.signUpForm).thenReturn(
      AuthUtils.buildSignUpForm(),
    );
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await TestUtils.pumpApp(
      tester,
      child: Material(child: SignUpFormWidget(cubit: mockAuthCubit)),
    );
    await tester.pump();
  }

  AppReactiveTextFieldWidget fieldByControl(
    WidgetTester tester,
    String controlName,
  ) =>
      tester.widget<AppReactiveTextFieldWidget>(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppReactiveTextFieldWidget &&
              widget.formControlName == controlName,
        ),
      );

  testWidgets('renders localized hints for all fields', (tester) async {
    await pumpWidget(tester);

    expect(fieldByControl(tester, 'name').hintText, 'Name');
    expect(fieldByControl(tester, 'email').hintText, 'Email');
    expect(fieldByControl(tester, 'password').hintText, 'Password');
    expect(
      fieldByControl(tester, 'confirmPassword').hintText,
      'Confirm Password',
    );
  });

  testWidgets('configures validation and obscuring for password fields', (
    tester,
  ) async {
    await pumpWidget(tester);

    final passwordField = fieldByControl(tester, 'password');
    expect(passwordField.obscureText, isTrue);
    expect(passwordField.suffixIcon, 'eye');
    expect(
      passwordField.validationMessages?.keys,
      containsAll([ValidationMessage.required, ValidationMessage.minLength]),
    );

    final confirmField = fieldByControl(tester, 'confirmPassword');
    expect(confirmField.obscureText, isTrue);
    expect(confirmField.suffixIcon, isNull);
    expect(
      confirmField.validationMessages?.keys,
      contains(ValidationMessage.mustMatch),
    );
  });

  testWidgets('toggles password visibility when suffix icon is tapped', (
    tester,
  ) async {
    await pumpWidget(tester);

    final eyeIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget && widget.icon == 'assets/icons/eye.svg',
    );

    await tester.tap(
      find.ancestor(of: eyeIcon, matching: find.byType(GestureDetector)),
    );
    await tester.pump();

    final passwordField = fieldByControl(tester, 'password');
    expect(passwordField.obscureText, isFalse);
    expect(passwordField.suffixIcon, 'eye_off');
  });
}
