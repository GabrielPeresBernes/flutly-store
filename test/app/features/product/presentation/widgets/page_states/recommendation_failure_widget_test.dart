import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/product/presentation/bloc/recommendation/product_recommendation_cubit.dart';
import 'package:flutly_store/app/features/product/presentation/widgets/page_states/recommendation_failure_widget.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockProductRecommendationCubit
    extends MockCubit<ProductRecommendationState>
    implements ProductRecommendationCubit {}

void main() {
  late ProductRecommendationCubit mockCubit;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    mockCubit = MockProductRecommendationCubit();
  });

  Future<void> pumpWidget(
    WidgetTester tester, {
    required AppException exception,
    required int productId,
  }) async {
    await TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<ProductRecommendationCubit>.value(value: mockCubit),
      ],
      child: Material(
        child: RecommendationFailureWidget(
          exception: exception,
          productId: productId,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('passes compact error message widget configuration', (
    tester,
  ) async {
    final exception = AppException(message: 'Failed to load');

    await pumpWidget(
      tester,
      exception: exception,
      productId: 12,
    );

    final widget = tester.widget<ErrorMessageWidget>(
      find.byType(ErrorMessageWidget),
    );

    expect(widget.error, exception);
    expect(widget.compact, isTrue);
    expect(widget.onRetry, isNotNull);
  });

  testWidgets('tapping retry calls cubit with product id', (tester) async {
    const productId = 42;
    final exception = AppException(message: 'Failed to load');

    when(
      () => mockCubit.getRecommendations(forProductId: productId),
    ).thenAnswer((_) async {});

    await pumpWidget(
      tester,
      exception: exception,
      productId: productId,
    );

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    verify(
      () => mockCubit.getRecommendations(forProductId: productId),
    ).called(1);
  });
}
