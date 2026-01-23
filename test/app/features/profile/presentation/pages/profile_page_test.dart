import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/features/auth/infra/routes/auth_route.dart';
import 'package:flutly_store/app/features/profile/infra/routes/edit_profile_route.dart';
import 'package:flutly_store/app/features/profile/infra/routes/report_bug_route.dart';
import 'package:flutly_store/app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late AppCubit appCubit;
  late RouterProvider routerProvider;

  const credentials = Credentials(
    userId: '1',
    name: 'Alice Doe',
    email: 'alice@test.com',
    provider: AuthProvider.email,
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    appCubit = MockAppCubit();
    routerProvider = MockRouterProvider();

    when(() => routerProvider.canPop()).thenReturn(false);
    when(() => appCubit.signOut()).thenAnswer((_) async {});
    when(() => appCubit.appFullVersion).thenReturn('1.2.3 (42)');
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required AppState state,
    Stream<AppState>? stream,
  }) {
    whenListen(
      appCubit,
      stream ?? Stream.value(state),
      initialState: state,
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<AppCubit>.value(value: appCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets('renders guest info and sign-in action', (tester) async {
    when(() => appCubit.isUserAuthenticated).thenReturn(false);

    await pumpApp(tester, state: const AppInitial());
    await tester.pumpAndSettle();

    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Sign in to your account'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('1.2.3 (42)'), findsOneWidget);
  });

  testWidgets('tapping sign in pushes auth route', (tester) async {
    when(() => appCubit.isUserAuthenticated).thenReturn(false);

    await pumpApp(tester, state: const AppInitial());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    verify(() => routerProvider.push(const AuthRoute())).called(1);
  });

  testWidgets('report bug opens auth required sheet when guest', (
    tester,
  ) async {
    when(() => appCubit.isUserAuthenticated).thenReturn(false);

    await pumpApp(tester, state: const AppInitial());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Report a Bug'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In Required'), findsOneWidget);
    expect(
      find.text('You need to be signed in to report a bug.'),
      findsOneWidget,
    );
  });

  testWidgets('renders authenticated actions and routes', (tester) async {
    when(() => appCubit.isUserAuthenticated).thenReturn(true);

    await pumpApp(
      tester,
      state: const AppUserRefreshed(
        credentials: credentials,
        hasChanged: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Alice Doe'), findsOneWidget);
    expect(find.text('alice@test.com'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);

    await tester.tap(find.text('Edit Profile'));
    await tester.pump();
    verify(() => routerProvider.push(const EditProfileRoute())).called(1);

    await tester.tap(find.text('Report a Bug'));
    await tester.pump();
    verify(() => routerProvider.push(const ReportBugRoute())).called(1);

    await tester.tap(find.text('Sign Out'));
    await tester.pump();
    verify(() => appCubit.signOut()).called(1);
  });
}
