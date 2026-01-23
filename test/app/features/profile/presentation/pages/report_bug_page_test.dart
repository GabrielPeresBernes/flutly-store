import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/profile/profile.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/extensions/show_app_snack_bar_extension.dart';
import 'package:flutly_store/app/shared/widgets/app_snack_bar_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_elevated_button_widget.dart';
import 'package:flutly_store/app/shared/widgets/inputs/app_reactive_dropdown_field_widget.dart';
import 'package:flutly_store/app/shared/widgets/inputs/app_reactive_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../utils/test_utils.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late ProfileCubit profileCubit;
  late RouterProvider routerProvider;

  FormGroup buildForm() => FormGroup({
    'description': FormControl<String>(),
    'stepsToReproduce': FormArray<String>([]),
    'expectedBehavior': FormControl<String>(),
    'issueType': FormControl<String>(),
    'screen': FormControl<String>(),
    'frequency': FormControl<String>(),
  });

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    profileCubit = MockProfileCubit();
    routerProvider = MockRouterProvider();

    when(() => profileCubit.bugReportForm).thenReturn(buildForm());

    when(() => profileCubit.reportBug()).thenAnswer((_) async {});

    when(() => routerProvider.canPop()).thenReturn(false);
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

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<ProfileCubit>.value(value: profileCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const ReportBugPage(),
      ),
    );
  }

  testWidgets('renders form fields and send button', (tester) async {
    await pumpApp(tester, state: const ProfileInitial());
    await tester.pumpAndSettle();

    expect(find.byType(AppReactiveTextFieldWidget), findsNWidgets(3));
    expect(find.byType(AppReactiveDropdownFieldWidget), findsNWidgets(2));
    expect(find.byType(DynamicListFieldWidget), findsOneWidget);
    expect(find.byType(AppElevatedButtonWidget), findsOneWidget);
  });

  testWidgets('tapping send triggers reportBug', (tester) async {
    await pumpApp(tester, state: const ProfileInitial());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(AppElevatedButtonWidget));
    await tester.pump();
    await tester.tap(find.byType(AppElevatedButtonWidget));
    await tester.pump();

    verify(() => profileCubit.reportBug()).called(1);
  });

  testWidgets('shows success snack bar when report succeeds', (tester) async {
    await pumpApp(
      tester,
      state: const ProfileInitial(),
      stream: Stream.fromIterable([const ProfileBugReported()]),
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
  });

  testWidgets('shows error snack bar when report fails', (tester) async {
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

  testWidgets('shows loading indicator while reporting', (tester) async {
    await pumpApp(tester, state: const ProfileLoading());
    await tester.pump();

    await tester.ensureVisible(find.byType(AppElevatedButtonWidget));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
