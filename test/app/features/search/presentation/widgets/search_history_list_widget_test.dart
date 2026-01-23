import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/search_history_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/search_history_list_widget.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/search_history_term_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../utils/test_utils.dart';

class MockSearchHistoryCubit extends MockCubit<SearchHistoryState>
    implements SearchHistoryCubit {}

class _HistoryListHost extends StatelessWidget {
  const _HistoryListHost();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
      builder: (context, state) {
        final terms = switch (state) {
          SearchHistoryLoaded(:final terms) => terms,
          SearchHistoryRemoved(:final terms) => terms,
          _ => const <String>[],
        };

        return SearchHistoryListWidget(terms: terms);
      },
    );
  }
}

void main() {
  late SearchHistoryCubit searchHistoryCubit;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    searchHistoryCubit = MockSearchHistoryCubit();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required SearchHistoryState state,
    Stream<SearchHistoryState>? stream,
  }) {
    whenListen(
      searchHistoryCubit,
      stream ?? const Stream<SearchHistoryState>.empty(),
      initialState: state,
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<SearchHistoryCubit>.value(value: searchHistoryCubit),
      ],
      child: const Material(child: _HistoryListHost()),
    );
  }

  testWidgets('renders the provided terms', (tester) async {
    const terms = ['Shoes', 'Backpack'];

    await pumpApp(
      tester,
      state: const SearchHistoryLoaded(terms),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchHistoryTermWidget), findsNWidgets(2));
    expect(find.text('Shoes'), findsOneWidget);
    expect(find.text('Backpack'), findsOneWidget);
  });

  testWidgets('removes term when cubit emits SearchHistoryRemoved', (
    tester,
  ) async {
    final controller = StreamController<SearchHistoryState>.broadcast();
    addTearDown(controller.close);

    await pumpApp(
      tester,
      state: const SearchHistoryLoaded(<String>['Shoes', 'Backpack']),
      stream: controller.stream,
    );
    await tester.pumpAndSettle();

    controller.add(
      const SearchHistoryRemoved(<String>['Backpack'], 'Shoes'),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchHistoryTermWidget), findsOneWidget);
    expect(find.text('Shoes'), findsNothing);
    expect(find.text('Backpack'), findsOneWidget);
  });
}
