import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../core/router/router.dart';
import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/app_icon_widget.dart';
import '../../../../catalog/infra/routes/catalog_route.dart';
import '../../../../catalog/infra/routes/catalog_route_params.dart';
import '../../bloc/history/search_history_cubit.dart';

class SearchSuggestionsLoadedWidget extends StatelessWidget {
  const SearchSuggestionsLoadedWidget({
    super.key,
    required this.suggestions,
  });

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('search.sections.related_terms'.tr(), style: context.bodyLarge),
        const SizedBox(height: 20),
        if (suggestions.isEmpty)
          TweenAnimationBuilder<Offset>(
            tween: Tween(begin: const Offset(0, 0.5), end: Offset.zero),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, offset, child) => FractionalTranslation(
              translation: offset,
              child: child,
            ),
            child: Text(
              'search.messages.no_suggestions'.tr(),
              style: context.bodyMedium.copyWith(color: AppColors.gray100),
            ),
          ),
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          context.read<SearchHistoryCubit>().saveSearchTerm(
                            suggestion,
                          );

                          context.router.push(
                            const CatalogRoute(),
                            params: CatalogRouteParams(term: suggestion),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.gray400),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  suggestion,
                                  style: context.labelMedium,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const AppIconWidget.svgAsset(
                                'chevron_right',
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
