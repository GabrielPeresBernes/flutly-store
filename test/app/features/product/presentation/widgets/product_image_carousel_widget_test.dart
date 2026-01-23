import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/product/domain/entities/product_extended.dart';
import 'package:flutly_store/app/features/product/presentation/bloc/product/product_cubit.dart';
import 'package:flutly_store/app/features/product/presentation/widgets/product_image_carousel_widget.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/widgets/app_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

void main() {
  late ProductCubit cubit;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    cubit = MockProductCubit();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required ProductState state,
  }) {
    whenListen(cubit, Stream.value(state), initialState: state);

    return TestUtils.pumpApp(
      tester,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(400, 800)),
        child: Material(
          child: ProductImageCarouselWidget(
            thumbnail: 'thumb.png',
            cubit: cubit,
          ),
        ),
      ),
    );
  }

  ProductExtended buildProduct({required List<String> images}) {
    return ProductExtended(
      id: 1,
      title: 'Phone',
      thumbnail: 'thumb.png',
      price: 100,
      rating: 4.5,
      description: 'Nice phone',
      brand: 'Brand',
      images: images,
      discountPercentage: 10,
    );
  }

  testWidgets('shows placeholder carousel on initial state', (tester) async {
    await pumpApp(tester, state: const ProductInitial());
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(AppNetworkImageWidget), findsOneWidget);
  });

  testWidgets('shows placeholder carousel when only one image', (
    tester,
  ) async {
    await pumpApp(
      tester,
      state: ProductLoaded(product: buildProduct(images: const ['img.png'])),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppNetworkImageWidget), findsOneWidget);
  });

  testWidgets('shows full carousel when multiple images', (tester) async {
    final product = buildProduct(
      images: const ['img1.png', 'img2.png', 'img3.png'],
    );

    await pumpApp(tester, state: ProductLoaded(product: product));
    await tester.pumpAndSettle();

    expect(find.byType(AnimatedContainer), findsNothing);
    expect(find.byType(AppNetworkImageWidget), findsNWidgets(3));
  });

  testWidgets('renders empty widget on failure', (tester) async {
    await pumpApp(
      tester,
      state: ProductFailure(
        exception: AppException(message: 'fail'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsNothing);
  });
}
