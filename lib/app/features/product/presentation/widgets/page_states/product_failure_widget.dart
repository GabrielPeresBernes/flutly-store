import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../../shared/theme/tokens/spacing_tokens.dart';
import '../../../../../shared/widgets/error_message_widget.dart';
import '../../bloc/product/product_cubit.dart';

class ProductFailureWidget extends StatelessWidget {
  const ProductFailureWidget({
    super.key,
    required this.exception,
    this.id,
  });

  final AppException exception;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        left: AppSpacing.pageHorizontalPadding,
        right: AppSpacing.pageHorizontalPadding,
      ),
      child: ErrorMessageWidget(
        error: exception,
        onRetry: () => context.read<ProductCubit>().getProductById(id),
      ),
    );
  }
}
