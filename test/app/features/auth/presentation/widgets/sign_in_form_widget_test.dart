import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutly_store/app/features/auth/presentation/widgets/sign_in_form_widget.dart';
import 'package:flutly_store/app/features/auth/utils/auth_utils.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutly_store/app/shared/widgets/inputs/app_reactive_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late AuthCubit mockAuthCubit;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    mockAuthCubit = MockAuthCubit();

    when(() => mockAuthCubit.signInForm).thenReturn(
      AuthUtils.buildSignInForm(),
    );
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
      ],
      child: const Material(child: SignInFormWidget()),
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

  testWidgets('renders localized hints and email action', (tester) async {
    await pumpWidget(tester);

    final emailField = fieldByControl(tester, 'email');
    expect(emailField.hintText, 'Email');
    expect(emailField.textInputAction, TextInputAction.next);
    expect(emailField.prefixIcon, 'mail');

    final passwordField = fieldByControl(tester, 'password');
    expect(passwordField.hintText, 'Password');
    expect(passwordField.prefixIcon, 'lock_2');
  });

  testWidgets('toggles password visibility when suffix icon is tapped', (
    tester,
  ) async {
    await pumpWidget(tester);

    final passwordField = fieldByControl(tester, 'password');
    expect(passwordField.obscureText, isTrue);
    expect(passwordField.suffixIcon, 'eye');

    final eyeIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget && widget.icon == 'assets/icons/eye.svg',
    );

    await tester.tap(
      find.ancestor(of: eyeIcon, matching: find.byType(GestureDetector)),
    );
    await tester.pump();

    final updatedPasswordField = fieldByControl(tester, 'password');
    expect(updatedPasswordField.obscureText, isFalse);
    expect(updatedPasswordField.suffixIcon, 'eye_off');
  });
}
