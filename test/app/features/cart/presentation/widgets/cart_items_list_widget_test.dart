import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart/cart_cubit.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/cart_items_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late CartCubit cartCubit;
  late RouterProvider routerProvider;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    cartCubit = MockCartCubit();
    routerProvider = MockRouterProvider();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required List<CartProduct> products,
    required Stream<CartState> stream,
  }) {
    whenListen(cartCubit, stream, initialState: const CartInitial());

    return TestUtils.pumpApp(
      tester,
      providers: [BlocProvider<CartCubit>.value(value: cartCubit)],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: Material(
          child: CartItemsListWidget(products: products),
        ),
      ),
    );
  }

  CartProduct buildProduct({
    required int id,
    required String name,
  }) => CartProduct(
    id: id,
    quantity: 1,
    thumbnail: 'thumb_$id.png',
    name: name,
    price: 10.0,
  );

  testWidgets('renders the provided cart items', (tester) async {
    final products = [
      buildProduct(id: 1, name: 'Phone'),
      buildProduct(id: 2, name: 'Case'),
    ];

    await pumpApp(
      tester,
      products: products,
      stream: const Stream<CartState>.empty(),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartItemWidget), findsNWidgets(2));
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Case'), findsOneWidget);
  });

  testWidgets('removes item when cart update is remove', (tester) async {
    final controller = StreamController<CartState>.broadcast();
    addTearDown(controller.close);

    final product = buildProduct(id: 1, name: 'Phone');

    await pumpApp(
      tester,
      products: [product],
      stream: controller.stream,
    );
    await tester.pumpAndSettle();
    expect(find.byType(CartItemWidget), findsOneWidget);

    controller.add(
      CartUpdated(
        cart: Cart.empty(),
        product: product,
        operation: CartOperation.remove,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartItemWidget), findsNothing);
  });

  testWidgets('inserts item when cart update is add', (tester) async {
    final controller = StreamController<CartState>.broadcast();
    addTearDown(controller.close);

    final products = [buildProduct(id: 1, name: 'Phone')];
    final newProduct = buildProduct(id: 2, name: 'Case');

    await pumpApp(
      tester,
      products: products,
      stream: controller.stream,
    );
    await tester.pumpAndSettle();

    products.add(newProduct);
    controller.add(
      CartUpdated(
        cart: Cart.empty(),
        product: newProduct,
        operation: CartOperation.add,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartItemWidget), findsNWidgets(2));
    expect(find.text('Case'), findsOneWidget);
  });
}
