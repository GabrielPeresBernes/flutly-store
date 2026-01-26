import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/cart/cart.dart';
import 'package:flutly_store/app/features/product/product.dart';
import 'package:flutly_store/app/features/search/infra/routes/search_route.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_elevated_button_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_outlined_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

class MockProductRecommendationCubit
    extends MockCubit<ProductRecommendationState>
    implements ProductRecommendationCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late ProductCubit productCubit;
  late ProductRecommendationCubit recommendationCubit;
  late CartCubit cartCubit;
  late RouterProvider routerProvider;

  const productId = 1;
  const productTitle = 'Phone';
  const productThumbnail = 'thumb.png';
  const productTag = '1';

  const product = ProductExtended(
    id: productId,
    title: productTitle,
    thumbnail: productThumbnail,
    price: 199.0,
    rating: 4.5,
    description: 'A phone',
    brand: 'Brand',
    images: ['img.png'],
    discountPercentage: 10.0,
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    productCubit = MockProductCubit();
    recommendationCubit = MockProductRecommendationCubit();
    cartCubit = MockCartCubit();
    routerProvider = MockRouterProvider();

    when(() => routerProvider.canPop()).thenReturn(false);
    when(() => productCubit.instanceId).thenReturn(123);
    when(
      () => cartCubit.addProduct(
        id: productId,
        thumbnail: productThumbnail,
        name: productTitle,
        price: product.price,
        uiID: 123,
      ),
    ).thenAnswer((_) async {
      return;
    });
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required ProductState productState,
    ProductRecommendationState recommendationState =
        const ProductRecommendationInitial(),
    CartState cartState = const CartInitial(),
  }) {
    whenListen(
      productCubit,
      Stream.value(productState),
      initialState: productState,
    );
    whenListen(
      recommendationCubit,
      Stream.value(recommendationState),
      initialState: recommendationState,
    );
    whenListen(
      cartCubit,
      Stream.value(cartState),
      initialState: cartState,
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<ProductCubit>.value(value: productCubit),
        BlocProvider<ProductRecommendationCubit>.value(
          value: recommendationCubit,
        ),
        BlocProvider<CartCubit>.value(value: cartCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const ProductPage(
          id: productId,
          title: productTitle,
          thumbnail: productThumbnail,
          tag: productTag,
        ),
      ),
    );
  }

  testWidgets('renders loading widget on initial state', (tester) async {
    await pumpApp(tester, productState: const ProductInitial());
    await tester.pumpAndSettle();

    expect(find.byType(ProductLoadingWidget), findsOneWidget);
  });

  testWidgets('renders failure widget and retries on tap', (tester) async {
    when(() => productCubit.getProductById(productId)).thenAnswer((_) async {});

    await pumpApp(
      tester,
      productState: ProductFailure(
        exception: AppException(message: 'failed'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductFailureWidget), findsOneWidget);
    await tester.tap(find.byType(AppOutlinedButtonWidget));
    await tester.pump();

    verify(() => productCubit.getProductById(productId)).called(1);
  });

  testWidgets('renders loaded widget and adds item to cart', (tester) async {
    when(
      () => cartCubit.addProduct(
        id: productId,
        thumbnail: productThumbnail,
        name: productTitle,
        price: product.price,
        uiID: 123,
      ),
    ).thenAnswer((_) async {});

    await pumpApp(
      tester,
      productState: const ProductLoaded(product: product),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductLoadedWidget), findsOneWidget);
    expect(find.byType(RecommendationLoadingWidget), findsOneWidget);

    await tester.ensureVisible(find.byType(AppElevatedButtonWidget));
    await tester.pump();
    await tester.tap(find.byType(AppElevatedButtonWidget));
    await tester.pumpAndSettle();

    verify(
      () => cartCubit.addProduct(
        id: productId,
        thumbnail: productThumbnail,
        name: productTitle,
        price: product.price,
        uiID: 123,
      ),
    ).called(1);
  });

  testWidgets('tapping search action pushes search route', (tester) async {
    await pumpApp(tester, productState: const ProductInitial());
    await tester.pumpAndSettle();

    final searchIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget && widget.icon == 'assets/icons/search.svg',
    );

    await tester.tap(
      find.ancestor(of: searchIcon, matching: find.byType(IconButton)),
    );
    await tester.pump();

    verify(() => routerProvider.push(const SearchRoute())).called(1);
  });

  testWidgets('cart update while adding product shows bottom sheet', (
    tester,
  ) async {
    await pumpApp(
      tester,
      productState: const ProductLoaded(product: product),
      cartState: CartUpdated(
        uiID: productCubit.instanceId,
        cart: Cart.empty(),
        product: CartProduct(
          id: product.id,
          thumbnail: product.thumbnail,
          name: product.title,
          price: product.price,
          quantity: 1,
        ),
        operation: CartOperation.add,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductAddedBottomSheetWidget), findsOneWidget);
  });

  testWidgets('shows loaded recommendation widget', (tester) async {
    await pumpApp(
      tester,
      productState: const ProductLoaded(product: product),
      recommendationState: const ProductRecommendationLoaded(products: []),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RecommendationLoadedWidget), findsOneWidget);
  });

  testWidgets('shows failure recommendation widget when recommendation fails', (
    tester,
  ) async {
    await pumpApp(
      tester,
      productState: const ProductLoaded(product: product),
      recommendationState: ProductRecommendationFailure(
        exception: AppException(message: 'failed'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RecommendationFailureWidget), findsOneWidget);
  });
}
