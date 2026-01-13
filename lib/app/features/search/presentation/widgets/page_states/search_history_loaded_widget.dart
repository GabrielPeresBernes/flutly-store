import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../search_history_list_widget.dart';

class SearchHistoryLoadedWidget extends StatelessWidget {
  const SearchHistoryLoadedWidget({
    super.key,
    required this.terms,
  });

  final List<String> terms;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
      child: terms.isEmpty
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'search.sections.recent_searches'.tr(),
                  style: context.bodyLarge,
                ),
                const SizedBox(height: 20),
                SearchHistoryListWidget(terms: terms),
                const SizedBox(height: 30),
              ],
            ),
    );
  }
}
