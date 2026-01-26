import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product_list.dart';
import 'package:flutly_store/app/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutly_store/app/features/home/presentation/pages/home_page.dart';
import 'package:flutly_store/app/features/home/presentation/widgets/page_states/home_failure_widget.dart';
import 'package:flutly_store/app/features/home/presentation/widgets/page_states/home_loaded_widget.dart';
import 'package:flutly_store/app/features/home/presentation/widgets/page_states/home_loading_widget.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_outlined_button_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late HomeCubit homeCubit;
  late AppCubit appCubit;
  late RouterProvider routerProvider;

  final productLists = [
    const HomeProductList(
      title: 'Highlights',
      products: [
        HomeProduct(
          id: 1,
          title: 'Phone',
          image: 'image.png',
          price: 100.0,
        ),
      ],
      type: HomeProductListType.highlight,
    ),
  ];

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    homeCubit = MockHomeCubit();
    appCubit = MockAppCubit();
    routerProvider = MockRouterProvider();

    when(() => routerProvider.canPop()).thenReturn(false);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required HomeState homeState,
    AppState appState = const AppInitial(),
  }) {
    whenListen(
      homeCubit,
      Stream.value(homeState),
      initialState: homeState,
    );
    whenListen(
      appCubit,
      Stream.value(appState),
      initialState: appState,
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<HomeCubit>.value(value: homeCubit),
        BlocProvider<AppCubit>.value(value: appCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const HomePage(),
      ),
    );
  }

  testWidgets('renders loading state by default', (tester) async {
    await pumpApp(tester, homeState: const HomeInitial());
    await tester.pumpAndSettle();

    expect(find.byType(HomeLoadingWidget), findsOneWidget);
  });

  testWidgets('renders loaded widget when products are available', (
    tester,
  ) async {
    await pumpApp(tester, homeState: HomeLoaded(productLists: productLists));
    await tester.pumpAndSettle();

    expect(find.byType(HomeLoadedWidget), findsOneWidget);
  });

  testWidgets('renders failure widget and retry handler', (tester) async {
    when(() => homeCubit.getProducts()).thenAnswer((_) async {});

    await pumpApp(
      tester,
      homeState: HomeFailure(exception: AppException(message: 'fail')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeFailureWidget), findsOneWidget);
    await tester.tap(find.byType(AppOutlinedButtonWidget));
    await tester.pump();

    verify(() => homeCubit.getProducts()).called(1);
  });

  testWidgets('shows personalized greeting when user is refreshed', (
    tester,
  ) async {
    const credentials = Credentials(
      userId: '1',
      name: 'Alice Doe',
      email: 'alice@test.com',
      provider: AuthProvider.email,
    );

    await pumpApp(
      tester,
      homeState: const HomeInitial(),
      appState: const AppUserRefreshed(credentials: credentials, hasChanged: false),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Alice'), findsOneWidget);
  });
}
