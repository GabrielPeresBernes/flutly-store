import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:flutly_store/app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/extensions/show_app_snack_bar_extension.dart';
import 'package:flutly_store/app/shared/widgets/app_snack_bar_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_elevated_button_widget.dart';
import 'package:flutly_store/app/shared/widgets/inputs/app_reactive_text_field_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../utils/test_utils.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late ProfileCubit profileCubit;
  late AppCubit appCubit;
  late RouterProvider routerProvider;

  FormGroup buildForm() => FormGroup({
    'name': FormControl<String>(),
    'email': FormControl<String>(),
    'currentPassword': FormControl<String>(),
    'newPassword': FormControl<String>(),
    'confirmNewPassword': FormControl<String>(),
  });

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    profileCubit = MockProfileCubit();
    appCubit = MockAppCubit();
    routerProvider = MockRouterProvider();

    when(() => routerProvider.canPop()).thenReturn(false);
    when(() => profileCubit.editProfileForm).thenReturn(buildForm());
    when(() => profileCubit.updateProfile()).thenAnswer((_) async {});
    when(() => appCubit.refreshUser()).thenAnswer((_) async {});
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required ProfileState state,
    Stream<ProfileState>? stream,
  }) {
    whenListen(
      profileCubit,
      stream ?? Stream.value(state),
      initialState: state,
    );
    whenListen(
      appCubit,
      Stream.value(const AppInitial()),
      initialState: const AppInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<AppCubit>.value(value: appCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const EditProfilePage(),
      ),
    );
  }

  testWidgets('renders form fields and save button', (tester) async {
    await pumpApp(tester, state: const ProfileInitial());
    await tester.pumpAndSettle();

    expect(find.byType(AppReactiveTextFieldWidget), findsNWidgets(5));
    expect(find.byType(AppElevatedButtonWidget), findsOneWidget);
  });

  testWidgets('tapping save triggers updateProfile', (tester) async {
    await pumpApp(tester, state: const ProfileInitial());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppElevatedButtonWidget));
    await tester.pump();

    verify(() => profileCubit.updateProfile()).called(1);
  });

  testWidgets('shows success snack bar and refreshes user', (tester) async {
    await pumpApp(
      tester,
      state: const ProfileInitial(),
      stream: Stream.fromIterable(
        [const ProfileUpdated()],
      ),
    );

    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppSnackBarWidget && widget.type == SnackBarType.success,
      ),
      findsOneWidget,
    );
    verify(() => appCubit.refreshUser()).called(1);
  });

  testWidgets('shows error snack bar on failure', (tester) async {
    await pumpApp(
      tester,
      state: const ProfileInitial(),
      stream: Stream.fromIterable(
        [ProfileFailure(exception: AppException(message: 'failed'))],
      ),
    );

    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppSnackBarWidget && widget.type == SnackBarType.error,
      ),
      findsOneWidget,
    );
  });
}
