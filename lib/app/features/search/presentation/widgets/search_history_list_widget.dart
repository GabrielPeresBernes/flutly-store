import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../bloc/search_history_cubit.dart';
import 'search_history_term_widget.dart';

class SearchHistoryListWidget extends StatefulWidget {
  const SearchHistoryListWidget({
    super.key,
    required this.terms,
  });

  final List<String> terms;

  @override
  State<SearchHistoryListWidget> createState() =>
      _SearchHistoryListWidgetState();
}

class _SearchHistoryListWidgetState extends State<SearchHistoryListWidget> {
  final _listKey = GlobalKey<AnimatedListState>();

  Widget _buildRemovedItem(
    String term,
    BuildContext context,
    Animation<double> animation,
  ) => SizeTransition(
    sizeFactor: animation,
    child: FadeTransition(
      opacity: animation,
      child: SearchHistoryTermWidget(term: term),
    ),
  );

  void _removeItem({required String term}) {
    final index = widget.terms.indexWhere((t) => t == term);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(term, context, animation),
      // ignore: avoid_redundant_argument_values
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchHistoryCubit, SearchHistoryState>(
      listener: (context, state) {
        if (state is SearchHistoryRemoved) {
          _removeItem(term: state.removedTerm);
        }
      },
      child: AnimationLimiter(
        child: AnimatedList(
          key: _listKey,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          initialItemCount: widget.terms.length,
          itemBuilder: (context, index, animation) {
            final term = widget.terms[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 300),
              child: SlideAnimation(
                horizontalOffset: 50,
                child: FadeInAnimation(
                  child: SearchHistoryTermWidget(term: term),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
