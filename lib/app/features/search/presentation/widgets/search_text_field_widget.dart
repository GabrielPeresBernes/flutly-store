import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/utils/string_utils.dart';
import '../../../../shared/widgets/inputs/app_text_field_widget.dart';
import '../../../catalog/infra/routes/catalog_route.dart';
import '../../../catalog/infra/routes/catalog_route_params.dart';
import '../bloc/history/search_history_cubit.dart';
import '../bloc/suggestions/search_suggestions_cubit.dart';

class SearchTextFieldWidget extends StatefulWidget {
  const SearchTextFieldWidget({super.key});

  @override
  State<SearchTextFieldWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  final _controller = TextEditingController();
  bool _showClearButton = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchSuggestionsCubit = context.read<SearchSuggestionsCubit>();

    final searchHistoryCubit = context.read<SearchHistoryCubit>();

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: AppTextFieldWidget(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          searchSuggestionsCubit.getSuggestions(value);
          setState(() => _showClearButton = value.isNotEmpty);
        },
        onSubmitted: (value) {
          searchHistoryCubit.saveSearchTerm(StringUtils.capitalize(value));

          context.router.push(
            const CatalogRoute(),
            params: CatalogRouteParams(term: value),
          );
        },
        prefixIcon: 'search',
        suffixIcon: _showClearButton ? 'close' : null,
        onSuffixPressed: () {
          setState(() => _showClearButton = false);

          _controller.clear();

          FocusScope.of(context).unfocus();

          searchSuggestionsCubit.getSuggestions('');
        },
        hintText: 'search.hint'.tr(),
      ),
    );
  }
}
