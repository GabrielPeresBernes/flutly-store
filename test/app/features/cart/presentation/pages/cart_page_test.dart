import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart/cart_cubit.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/popular_products/cart_popular_products_cubit.dart';
import 'package:flutly_store/app/features/cart/presentation/pages/cart_page.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/page_states/cart_empty_widget.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/page_states/cart_failure_widget.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/page_states/cart_loaded_widget.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/page_states/cart_loading_widget.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/page_states/popular_products_failure_widget.dart';
import 'package:flutly_store/app/features/product/product.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/widgets/products/medium_product_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockCartPopularProductsCubit extends MockCubit<CartPopularProductsState>
    implements CartPopularProductsCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  late CartCubit cartCubit;
  late CartPopularProductsCubit popularProductsCubit;
  late AppCubit appCubit;

  const product = Product(
    id: 1,
    thumbnail: 'thumb.png',
    title: 'Popular Item',
    price: 10.0,
  );

  const cartProduct = CartProduct(
    id: 1,
    quantity: 1,
    thumbnail: 'thumb.png',
    name: 'Item',
    price: 10.0,
  );

  const cart = Cart(
    totalPrice: 10.0,
    totalItems: 1,
    products: {1: cartProduct},
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    cartCubit = MockCartCubit();
    popularProductsCubit = MockCartPopularProductsCubit();
    appCubit = MockAppCubit();

    when(() => popularProductsCubit.getProducts()).thenAnswer((_) async {});
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    CartState? cartState,
    Stream<CartState>? cartStream,
    CartPopularProductsState? popularProductsState,
    Stream<CartPopularProductsState>? popularProductsStream,
  }) {
    whenListen(
      cartCubit,
      cartStream ?? Stream.fromIterable([cartState ?? const CartInitial()]),
      initialState: cartState ?? const CartInitial(),
    );

    whenListen(
      popularProductsCubit,
      popularProductsStream ?? Stream.value(const CartPopularProductsInitial()),
      initialState: popularProductsState ?? const CartPopularProductsInitial(),
    );

    whenListen(
      appCubit,
      Stream.fromIterable([const AppInitial()]),
      initialState: const AppInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<CartCubit>.value(value: cartCubit),
        BlocProvider<CartPopularProductsCubit>.value(
          value: popularProductsCubit,
        ),
        BlocProvider<AppCubit>.value(value: appCubit),
      ],
      child: const CartPage(),
    );
  }

  for (final state in [const CartInitial(), const CartLoading()]) {
    testWidgets('renders loading widget for $state', (tester) async {
      await pumpApp(
        tester,
        cartStream: Stream.fromIterable([state]),
        cartState: state,
      );
      await tester.pumpAndSettle();

      expect(find.byType(CartLoadingWidget), findsOneWidget);
    });
  }

  testWidgets('renders failure widget when cart load fails', (
    tester,
  ) async {
    await pumpApp(
      tester,
      cartStream: Stream.fromIterable([
        CartFailure(exception: AppException(message: 'fail')),
      ]),
      cartState: CartFailure(exception: AppException(message: 'fail')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartFailureWidget), findsOneWidget);
  });

  testWidgets('renders empty widget and requests popular products', (
    tester,
  ) async {
    await pumpApp(
      tester,
      cartStream: Stream.fromIterable([const CartEmpty()]),
      cartState: const CartEmpty(),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartEmptyWidget), findsOneWidget);
    verify(() => popularProductsCubit.getProducts()).called(1);
  });

  testWidgets('renders loaded widget for CartLoaded', (tester) async {
    await pumpApp(
      tester,
      cartState: const CartLoaded(cart: cart),
      cartStream: Stream.fromIterable([const CartLoaded(cart: cart)]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartLoadedWidget), findsOneWidget);
  });

  testWidgets('renders loaded widget for CartUpdated', (tester) async {
    await pumpApp(
      tester,
      cartState: const CartEmpty(),
      cartStream: Stream.fromIterable([
        const CartUpdated(
          cart: cart,
          product: cartProduct,
          operation: CartOperation.add,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CartLoadedWidget), findsOneWidget);
  });

  testWidgets('renders loaded popular products widget', (tester) async {
    await pumpApp(
      tester,
      cartState: const CartEmpty(),
      cartStream: Stream.fromIterable([const CartEmpty()]),
      popularProductsState: const CartPopularProductsLoaded(
        products: [product],
      ),
      popularProductsStream: Stream.fromIterable([
        const CartPopularProductsLoaded(products: [product]),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MediumProductCardWidget), findsOneWidget);
  });

  testWidgets(
    'renders popular products failure widget when popular products load fails',
    (tester) async {
      await pumpApp(
        tester,
        cartState: const CartEmpty(),
        cartStream: Stream.fromIterable([const CartEmpty()]),
        popularProductsState: CartPopularProductsFailure(
          exception: AppException(message: 'fail'),
        ),
        popularProductsStream: Stream.fromIterable([
          CartPopularProductsFailure(
            exception: AppException(message: 'fail'),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PopularProductsFailureWidget), findsOneWidget);
    },
  );
}
