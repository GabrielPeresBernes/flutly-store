import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/layout_extension.dart';
import '../../bloc/search_history_cubit.dart';
import '../../bloc/search_popular_products_cubit.dart';
import 'search_history_loaded_widget.dart';
import 'search_history_loading_widget.dart';
import 'search_popular_products_loaded_widget.dart';
import 'search_popular_products_loading_widget.dart';

class SearchSuggestionsInitialWidget extends StatelessWidget {
  const SearchSuggestionsInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
            buildWhen: (previous, current) =>
                current is SearchHistoryLoading ||
                current is SearchHistoryInitial ||
                current is SearchHistoryLoaded ||
                current is SearchHistoryRemoved,
            builder: (context, state) {
              return switch (state) {
                SearchHistoryLoading() ||
                SearchHistoryInitial() => const SearchHistoryLoadingWidget(),

                SearchHistoryLoaded(:final terms) ||
                SearchHistoryRemoved(:final terms) => SearchHistoryLoadedWidget(
                  terms: terms,
                ),

                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: context.bottomBarOffset),
          sliver: SliverToBoxAdapter(
            child:
                BlocBuilder<
                  SearchPopularProductsCubit,
                  SearchPopularProductsState
                >(
                  builder: (context, state) {
                    return switch (state) {
                      SearchPopularProductsLoading() ||
                      SearchPopularProductsInitial() =>
                        const SearchPopularProductsLoadingWidget(),

                      SearchPopularProductsLoaded(:final products) =>
                        SearchPopularProductsLoadedWidget(products: products),

                      SearchPopularProductsFailure() => const SizedBox.shrink(),
                    };
                  },
                ),
          ),
        ),
      ],
    );
  }
}
