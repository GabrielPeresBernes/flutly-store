import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutly_store/app/features/auth/presentation/widgets/sign_up_bottom_sheet_widget.dart';
import 'package:flutly_store/app/features/auth/presentation/widgets/sign_up_form_widget.dart';
import 'package:flutly_store/app/features/auth/utils/auth_utils.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_elevated_button_widget.dart';
import 'package:flutter/material.dart';
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

    when(() => mockAuthCubit.signUpWithEmail()).thenAnswer((_) async {});

    when(
      () => mockAuthCubit.signUpForm,
    ).thenReturn(AuthUtils.buildSignUpForm());
  });

  Future<void> pumpWidget(WidgetTester tester, AuthState state) async {
    whenListen(
      mockAuthCubit,
      Stream<AuthState>.fromIterable([state]),
      initialState: state,
    );

    await TestUtils.pumpApp(
      tester,
      child: Material(child: SignUpBottomSheetWidget(cubit: mockAuthCubit)),
    );
  }

  testWidgets('renders title, form, and sign up button', (tester) async {
    await pumpWidget(tester, const AuthInitial());
    await tester.pump();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.byType(SignUpFormWidget), findsOneWidget);

    final button = tester.widget<AppElevatedButtonWidget>(
      find.byType(AppElevatedButtonWidget),
    );
    expect(button.label, 'Sign Up');
    expect(button.isLoading, isFalse);
    expect(button.suffixIcon, isNull);
  });

  testWidgets('tapping sign up triggers cubit', (tester) async {
    await pumpWidget(tester, const AuthInitial());
    await tester.pump();

    await tester.tap(find.byType(AppElevatedButtonWidget));
    await tester.pump();

    verify(() => mockAuthCubit.signUpWithEmail()).called(1);
  });

  testWidgets('shows loading state during auth', (tester) async {
    await pumpWidget(tester, const AuthLoading());
    await tester.pump();

    final button = tester.widget<AppElevatedButtonWidget>(
      find.byType(AppElevatedButtonWidget),
    );
    expect(button.isLoading, isTrue);
  });

  testWidgets('shows success icon when signed up', (tester) async {
    await pumpWidget(tester, const AuthSigned(AuthOperation.signUp));
    await tester.pump();

    final button = tester.widget<AppElevatedButtonWidget>(
      find.byType(AppElevatedButtonWidget),
    );
    expect(button.isLoading, isFalse);
    expect(button.suffixIcon, 'check');
  });
}
