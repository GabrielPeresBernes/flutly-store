import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/catalog/domain/entities/product_filters.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route_params.dart';
import 'package:flutly_store/app/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:flutly_store/app/features/catalog/presentation/bloc/catalog_filters_cubit.dart';
import 'package:flutly_store/app/features/catalog/presentation/pages/catalog_page.dart';
import 'package:flutly_store/app/features/catalog/presentation/widgets/filters_button_widget.dart';
import 'package:flutly_store/app/features/catalog/presentation/widgets/page_states/catalog_empty_widget.dart';
import 'package:flutly_store/app/features/catalog/presentation/widgets/page_states/catalog_initial_error_widget.dart';
import 'package:flutly_store/app/features/catalog/presentation/widgets/page_states/catalog_initial_loading_widget.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/widgets/products/medium_product_card_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockCatalogBloc extends MockBloc<CatalogEvent, PagingState<int, Product>>
    implements CatalogBloc {}

class MockCatalogFiltersCubit extends MockCubit<CatalogFiltersState>
    implements CatalogFiltersCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late CatalogBloc catalogBloc;
  late CatalogFiltersCubit filtersCubit;
  late RouterProvider routerProvider;

  final emptyPagingState = PagingState<int, Product>(
    pages: const [],
    keys: const [],
    hasNextPage: false,
  );

  final failurePagingState = PagingState<int, Product>(
    pages: const [],
    keys: const [],
    hasNextPage: false,
    error: AppException(message: 'Failed to fetch products'),
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(const CatalogGetProducts());
  });

  setUp(() {
    catalogBloc = MockCatalogBloc();
    filtersCubit = MockCatalogFiltersCubit();
    routerProvider = MockRouterProvider();

    when(() => filtersCubit.appliedFiltersCount).thenReturn(0);
    when(
      () => routerProvider.getParams<CatalogRouteParams>(),
    ).thenReturn(null);
    when(() => routerProvider.canPop()).thenReturn(false);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required PagingState<int, Product> catalogState,
    Stream<CatalogFiltersState>? filtersStream,
  }) {
    whenListen(
      catalogBloc,
      Stream.value(catalogState),
      initialState: catalogState,
    );
    whenListen(
      filtersCubit,
      filtersStream ?? Stream.value(const CatalogFiltersInitial()),
      initialState: const CatalogFiltersInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<CatalogBloc>.value(value: catalogBloc),
        BlocProvider<CatalogFiltersCubit>.value(value: filtersCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const CatalogPage(),
      ),
    );
  }

  testWidgets('renders catalog title from route params', (tester) async {
    when(
      () => routerProvider.getParams<CatalogRouteParams>(),
    ).thenReturn(const CatalogRouteParams(term: 'phone'));

    await pumpApp(tester, catalogState: emptyPagingState);
    await tester.pumpAndSettle();

    expect(find.text('Phone'), findsWidgets);
  });

  testWidgets('renders filters button and badge count', (tester) async {
    when(() => filtersCubit.appliedFiltersCount).thenReturn(2);

    await pumpApp(tester, catalogState: emptyPagingState);
    await tester.pumpAndSettle();

    expect(find.byType(FiltersButtonWidget), findsOneWidget);
    expect(find.text('2'), findsWidgets);
  });

  testWidgets('renders empty widget when there are no items', (
    tester,
  ) async {
    await pumpApp(tester, catalogState: emptyPagingState);
    await tester.pumpAndSettle();

    expect(find.byType(CatalogEmptyWidget), findsOneWidget);
  });

  testWidgets('renders initial error widget', (
    tester,
  ) async {
    await pumpApp(tester, catalogState: failurePagingState);
    await tester.pumpAndSettle();

    expect(find.byType(CatalogInitialErrorWidget), findsOneWidget);
  });

  testWidgets('listens to filters and requests reset fetch', (
    tester,
  ) async {
    final filtersStream = Stream.value(
      const CatalogFiltersApplied(
        filters: ProductFilters(minPrice: 10, maxPrice: 50),
      ),
    );

    await pumpApp(
      tester,
      catalogState: emptyPagingState,
      filtersStream: filtersStream,
    );
    await tester.pump();

    final captured =
        verify(() => catalogBloc.add(captureAny())).captured.single
            as CatalogGetProducts;
    expect(captured.reset, isTrue);
    expect(captured.filters?.minPrice, 10);
    expect(captured.filters?.maxPrice, 50);
  });

  testWidgets('fetch next page when scrolling', (
    tester,
  ) async {
    final pagingStateWithData = PagingState<int, Product>(
      pages: [
        List.generate(
          10,
          (index) => Product(
            id: index,
            title: 'Product $index',
            price: 10.0 + index,
            thumbnail: 'http://example.com/product_$index.png',
          ),
        ),
      ],
      keys: [0],
    );

    await pumpApp(tester, catalogState: pagingStateWithData);
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(MediumProductCardWidget).first,
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();

    verify(
      () => catalogBloc.add(any(that: isA<CatalogGetProducts>())),
    ).called(1);
  });
}
