import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../../shared/widgets/error_message_widget.dart';
import '../../bloc/catalog/catalog_bloc.dart';

class CatalogInitialErrorWidget extends StatelessWidget {
  const CatalogInitialErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorMessageWidget(
      error: AppException(
        message: 'catalog.errors.initial'.tr(),
      ),
      compact: true,
      onRetry: () => context.read<CatalogBloc>().add(
        const CatalogGetProducts(),
      ),
    );
  }
}
