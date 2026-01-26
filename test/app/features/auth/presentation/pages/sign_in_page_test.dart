import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutly_store/app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutly_store/app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutly_store/app/features/auth/presentation/widgets/sign_in_form_widget.dart';
import 'package:flutly_store/app/features/auth/presentation/widgets/social_sign_in_button_widget.dart';
import 'package:flutly_store/app/features/auth/utils/auth_utils.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/extensions/show_app_snack_bar_extension.dart';
import 'package:flutly_store/app/shared/widgets/app_snack_bar_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_elevated_button_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../utils/test_utils.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockSignInForm extends Mock implements FormGroup {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late AuthCubit mockAuthCubit;
  late AppCubit mockAppCubit;
  late RouterProvider routerProvider;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(AuthProvider.email);
  });

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    mockAppCubit = MockAppCubit();
    routerProvider = MockRouterProvider();

    when(
      () => mockAuthCubit.signInWithProvider(any()),
    ).thenAnswer((_) async {
      return;
    });

    when(
      () => mockAuthCubit.signInForm,
    ).thenReturn(AuthUtils.buildSignInForm());

    when(
      () => mockAuthCubit.signUpForm,
    ).thenReturn(AuthUtils.buildSignUpForm());

    when(() => mockAppCubit.refreshUser()).thenAnswer((_) async {
      return;
    });

    when(() => routerProvider.pop()).thenAnswer((_) async {
      return;
    });

    whenListen(
      mockAuthCubit,
      Stream.fromIterable([const AuthInitial()]),
      initialState: const AuthInitial(),
    );
  });

  Future<void> pumpApp(WidgetTester tester) => TestUtils.pumpApp(
    tester,
    providers: [
      BlocProvider<AuthCubit>.value(value: mockAuthCubit),
      BlocProvider<AppCubit>.value(value: mockAppCubit),
    ],
    child: CoreRouterScope(
      coreRouter: CoreRouter(routes: [], provider: routerProvider),
      child: const SignInPage(isIOSOverrideForTesting: true),
    ),
  );

  testWidgets('renders sign-in form and action buttons', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.byType(SignInFormWidget), findsOneWidget);
    expect(find.byType(AppElevatedButtonWidget), findsOneWidget);
    expect(find.byType(SocialSignInButtonWidget), findsNWidgets(2));
  });

  testWidgets('tapping login triggers email sign-in', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppElevatedButtonWidget));
    await tester.pump();

    verify(
      () => mockAuthCubit.signInWithProvider(AuthProvider.email),
    ).called(1);
  });

  testWidgets('tapping google button triggers google sign-in', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    final googleButton = find.byWidgetPredicate(
      (widget) => widget is SocialSignInButtonWidget && widget.icon == 'google',
    );

    await tester.tap(googleButton);
    await tester.pump();

    verify(
      () => mockAuthCubit.signInWithProvider(AuthProvider.google),
    ).called(1);
  });

  testWidgets('tapping apple button triggers apple sign-in on iOS', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    final appleButton = find.byWidgetPredicate(
      (widget) => widget is SocialSignInButtonWidget && widget.icon == 'apple',
    );

    await tester.tap(appleButton);
    await tester.pump();

    verify(
      () => mockAuthCubit.signInWithProvider(AuthProvider.apple),
    ).called(1);
  });

  testWidgets(
    'shows success snack bar, refresh and pop screen when user signUp',
    (tester) async {
      whenListen(
        mockAuthCubit,
        Stream.fromIterable([
          const AuthInitial(),
          const AuthSigned(AuthOperation.signUp),
        ]),
        initialState: const AuthInitial(),
      );

      await pumpApp(tester);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppSnackBarWidget &&
              widget.type == SnackBarType.success,
        ),
        findsOneWidget,
      );

      verify(() => mockAppCubit.refreshUser()).called(1);

      verify(() => routerProvider.pop()).called(2);
    },
  );

  testWidgets(
    'shows error snack bar when auth fails',
    (tester) async {
      whenListen(
        mockAuthCubit,
        Stream.fromIterable([
          const AuthInitial(),
          AuthFailure(AppException(message: 'Sign-in failed')),
        ]),
        initialState: const AuthInitial(),
      );

      await pumpApp(tester);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppSnackBarWidget && widget.type == SnackBarType.error,
        ),
        findsOneWidget,
      );

      verifyNever(() => mockAppCubit.refreshUser());
    },
  );
}
