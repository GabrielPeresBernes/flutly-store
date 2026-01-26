import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/history/search_history_cubit.dart';
import '../../presentation/bloc/popular_products/search_popular_products_cubit.dart';
import '../../presentation/bloc/suggestions/search_suggestions_cubit.dart';
import '../../presentation/pages/search_page.dart';

class SearchRoute extends CoreRoute {
  const SearchRoute();

  @override
  String get path => '/search';

  @override
  Widget builder(BuildContext context, _) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            CoreInjector.instance.get<SearchPopularProductsCubit>()
              ..getPopularProducts(),
      ),
      BlocProvider(
        create: (context) =>
            CoreInjector.instance.get<SearchHistoryCubit>()..getSearchHistory(),
      ),
      BlocProvider(
        create: (context) =>
            CoreInjector.instance.get<SearchSuggestionsCubit>(),
      ),
    ],
    child: const SearchPage(),
  );
}
