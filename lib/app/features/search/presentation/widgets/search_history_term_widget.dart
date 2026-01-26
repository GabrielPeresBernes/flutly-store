import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../../catalog/infra/routes/catalog_route.dart';
import '../../../catalog/infra/routes/catalog_route_params.dart';
import '../bloc/history/search_history_cubit.dart';

class SearchHistoryTermWidget extends StatelessWidget {
  const SearchHistoryTermWidget({
    super.key,
    required this.term,
  });

  final String term;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(
        const CatalogRoute(),
        params: CatalogRouteParams(term: term),
      ),
      child: Row(
        children: [
          const AppIconWidget.svgAsset('clock', size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(term, style: context.bodyMedium),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () =>
                context.read<SearchHistoryCubit>().removeSearchTerm(term),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: AppIconWidget.svgAsset('close', size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
