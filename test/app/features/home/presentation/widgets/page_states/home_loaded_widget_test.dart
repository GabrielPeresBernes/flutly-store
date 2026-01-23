import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route_params.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product.dart';
import 'package:flutly_store/app/features/home/domain/entities/home_product_list.dart';
import 'package:flutly_store/app/features/home/presentation/widgets/page_states/home_loaded_widget.dart';
import 'package:flutly_store/app/shared/widgets/products/large_product_card_widget.dart';
import 'package:flutly_store/app/shared/widgets/products/medium_product_card_widget.dart';
import 'package:flutly_store/app/shared/widgets/products/product_list_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late RouterProvider routerProvider;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(const CatalogRoute());
  });

  setUp(() {
    routerProvider = MockRouterProvider();

    when(
      () => routerProvider.push(any(), params: any(named: 'params')),
    ).thenReturn(null);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required List<HomeProductList> productLists,
  }) {
    return TestUtils.pumpApp(
      tester,
      child: CustomScrollView(
        slivers: [
          CoreRouterScope(
            coreRouter: CoreRouter(routes: const [], provider: routerProvider),
            child: HomeLoadedWidget(productLists: productLists),
          ),
        ],
      ),
    );
  }

  HomeProduct buildProduct(int id, String title) => HomeProduct(
    id: id,
    title: title,
    image: 'image_$id.png',
    price: 10.0,
  );

  testWidgets('renders highlight list with large cards', (tester) async {
    final productLists = [
      HomeProductList(
        title: 'Highlights',
        type: HomeProductListType.highlight,
        products: [
          buildProduct(1, 'Phone'),
          buildProduct(2, 'Tablet'),
        ],
      ),
    ];

    await pumpApp(tester, productLists: productLists);
    await tester.pumpAndSettle();

    expect(find.byType(LargeProductCardWidget), findsNWidgets(2));
    expect(find.byType(MediumProductCardWidget), findsNothing);
    expect(find.byType(ProductListTitleWidget), findsNothing);
  });

  testWidgets('renders normal list with title and medium cards', (
    tester,
  ) async {
    final productLists = [
      HomeProductList(
        title: 'New Arrivals',
        type: HomeProductListType.normal,
        products: [
          buildProduct(1, 'Phone'),
          buildProduct(2, 'Tablet'),
        ],
      ),
    ];

    await pumpApp(tester, productLists: productLists);
    await tester.pumpAndSettle();

    expect(find.byType(ProductListTitleWidget), findsOneWidget);
    expect(find.byType(MediumProductCardWidget), findsNWidgets(2));
    expect(find.byType(LargeProductCardWidget), findsNothing);
  });

  testWidgets('tapping title navigates to catalog with term', (
    tester,
  ) async {
    const title = 'New Arrivals';

    await pumpApp(
      tester,
      productLists: [
        HomeProductList(
          title: title,
          type: HomeProductListType.normal,
          products: [buildProduct(1, 'Phone')],
        ),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('See All'));
    await tester.pump();

    verify(
      () => routerProvider.push(
        const CatalogRoute(),
        params: const CatalogRouteParams(term: title),
      ),
    ).called(1);
  });
}
