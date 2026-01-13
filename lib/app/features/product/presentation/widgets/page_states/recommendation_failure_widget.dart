import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../../shared/widgets/error_message_widget.dart';
import '../../bloc/recommendation/product_recommendation_cubit.dart';

class RecommendationFailureWidget extends StatelessWidget {
  const RecommendationFailureWidget({
    super.key,
    required this.exception,
    required this.productId,
  });

  final AppException exception;
  final int productId;

  @override
  Widget build(BuildContext context) {
    return ErrorMessageWidget(
      error: exception,
      compact: true,
      onRetry: () =>
          context.read<ProductRecommendationCubit>().getRecommendations(
            forProductId: productId,
          ),
    );
  }
}
