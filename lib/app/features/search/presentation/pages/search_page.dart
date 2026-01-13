import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../bloc/search_suggestions_cubit.dart';
import '../widgets/page_states/search_suggestions_initial_widget.dart';
import '../widgets/page_states/search_suggestions_loaded_widget.dart';
import '../widgets/page_states/search_suggestions_loading_widget.dart';
import '../widgets/search_text_field_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopNavigationBar(title: 'search.title'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SearchTextFieldWidget(),
            const SizedBox(height: 30),
            Expanded(
              child:
                  BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
                    builder: (context, state) {
                      return switch (state) {
                        SearchSuggestionsLoading() =>
                          const SearchSuggestionsLoadingWidget(),

                        SearchSuggestionsLoaded(:final suggestions) =>
                          SearchSuggestionsLoadedWidget(
                            suggestions: suggestions,
                          ),

                        SearchSuggestionsInitial() ||
                        SearchSuggestionsFailure() ||
                        SearchSuggestionsReset() =>
                          const SearchSuggestionsInitialWidget(),
                      };
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
