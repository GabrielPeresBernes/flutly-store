import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router/router.dart';
import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/widgets/buttons/app_outlined_button_widget.dart';
import '../../../infra/routes/catalog_route_params.dart';
import '../../bloc/catalog/catalog_bloc.dart';

class CatalogNewPageErrorWidget extends StatelessWidget {
  const CatalogNewPageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final catalogBloc = context.read<CatalogBloc>();

    final params = context.router.getParams<CatalogRouteParams>();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'catalog.errors.new_page'.tr(),
            textAlign: TextAlign.center,
            style: context.bodyMedium,
          ),
          const SizedBox(height: 16),
          AppOutlinedButtonWidget(
            label: 'catalog.actions.retry'.tr(),
            onPressed: () => catalogBloc.add(
              CatalogGetProducts(
                searchTerm: params?.term,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
