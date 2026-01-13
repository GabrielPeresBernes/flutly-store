import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class SearchSuggestionsLoadingWidget extends StatelessWidget {
  const SearchSuggestionsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('search.sections.related_terms'.tr(), style: context.bodyLarge),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.gray400),
                  ),
                ),
                child: const Row(
                  children: [
                    ShimmerPlaceHolderWidget(width: 200, height: 16),
                    Spacer(),
                    ShimmerPlaceHolderWidget(width: 20, height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
