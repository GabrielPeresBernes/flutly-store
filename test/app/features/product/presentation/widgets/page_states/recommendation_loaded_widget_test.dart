import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/features/product/presentation/widgets/page_states/recommendation_loaded_widget.dart';
import 'package:flutly_store/app/shared/widgets/products/medium_product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late RouterProvider routerProvider;

  const products = [
    Product(id: 1, title: 'Phone', thumbnail: 'phone.png', price: 199.0),
    Product(id: 2, title: 'Watch', thumbnail: 'watch.png', price: 149.0),
  ];

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    routerProvider = MockRouterProvider();
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await TestUtils.pumpApp(
      tester,
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const Material(
          child: RecommendationLoadedWidget(products: products),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders title and product cards', (tester) async {
    await pumpWidget(tester);

    expect(find.text('More Products'), findsOneWidget);
    expect(find.byType(MediumProductCardWidget), findsNWidgets(2));
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Watch'), findsOneWidget);
  });

  testWidgets('tapping see all pushes catalog route', (tester) async {
    await pumpWidget(tester);

    await tester.tap(find.text('See All'));
    await tester.pump();

    verify(() => routerProvider.push(const CatalogRoute())).called(1);
  });
}
