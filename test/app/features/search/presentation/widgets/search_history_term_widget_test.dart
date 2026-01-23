import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route_params.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/search_history_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/search_history_term_widget.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockSearchHistoryCubit extends MockCubit<SearchHistoryState>
    implements SearchHistoryCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late SearchHistoryCubit searchHistoryCubit;
  late RouterProvider routerProvider;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(const CatalogRoute());
    registerFallbackValue(const CatalogRouteParams(term: ''));
  });

  setUp(() {
    searchHistoryCubit = MockSearchHistoryCubit();
    routerProvider = MockRouterProvider();

    when(() => searchHistoryCubit.state).thenReturn(
      const SearchHistoryInitial(),
    );
    when(() => searchHistoryCubit.removeSearchTerm(any())).thenAnswer(
      (_) async {},
    );
    when(
      () => routerProvider.push(
        any(),
        params: any(named: 'params'),
      ),
    ).thenAnswer((_) {});
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required String term,
  }) {
    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<SearchHistoryCubit>.value(value: searchHistoryCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: Material(
          child: SearchHistoryTermWidget(term: term),
        ),
      ),
    );
  }

  testWidgets('tapping term pushes catalog route', (tester) async {
    const term = 'Sneakers';

    await pumpApp(tester, term: term);
    await tester.pumpAndSettle();

    await tester.tap(find.text(term));
    await tester.pump();

    verify(
      () => routerProvider.push(
        const CatalogRoute(),
        params: const CatalogRouteParams(term: term),
      ),
    ).called(1);
  });

  testWidgets('tapping close icon removes term', (tester) async {
    const term = 'Sneakers';

    await pumpApp(tester, term: term);
    await tester.pumpAndSettle();

    final closeIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
    );
    await tester.tap(
      find.ancestor(of: closeIcon, matching: find.byType(InkWell)),
    );
    await tester.pump();

    verify(() => searchHistoryCubit.removeSearchTerm(term)).called(1);
    verifyNever(
      () => routerProvider.push(
        any(),
        params: any(named: 'params'),
      ),
    );
  });
}
