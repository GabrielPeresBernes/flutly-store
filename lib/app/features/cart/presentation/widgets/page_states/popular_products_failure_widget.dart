import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../../shared/widgets/error_message_widget.dart';
import '../../bloc/cart_popular_products_cubit.dart';

class PopularProductsFailureWidget extends StatelessWidget {
  const PopularProductsFailureWidget({
    super.key,
    required this.exception,
  });

  final AppException exception;

  @override
  Widget build(BuildContext context) {
    return ErrorMessageWidget(
      error: exception,
      compact: true,
      onRetry: () => context.read<CartPopularProductsCubit>().getProducts(),
    );
  }
}
