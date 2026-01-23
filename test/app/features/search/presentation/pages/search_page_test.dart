import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/product/domain/entities/product.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/search_history_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/search_popular_products_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/search_suggestions_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/pages/search_page.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/page_states/search_suggestions_initial_widget.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/page_states/search_suggestions_loaded_widget.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/page_states/search_suggestions_loading_widget.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/search_text_field_widget.dart';
import 'package:flutly_store/app/features/search/search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockSearchSuggestionsCubit extends MockCubit<SearchSuggestionsState>
    implements SearchSuggestionsCubit {}

class MockSearchHistoryCubit extends MockCubit<SearchHistoryState>
    implements SearchHistoryCubit {}

class MockSearchPopularProductsCubit
    extends MockCubit<SearchPopularProductsState>
    implements SearchPopularProductsCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late SearchSuggestionsCubit suggestionsCubit;
  late SearchHistoryCubit historyCubit;
  late SearchPopularProductsCubit popularProductsCubit;
  late RouterProvider routerProvider;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    suggestionsCubit = MockSearchSuggestionsCubit();
    historyCubit = MockSearchHistoryCubit();
    popularProductsCubit = MockSearchPopularProductsCubit();
    routerProvider = MockRouterProvider();

    when(() => routerProvider.canPop()).thenReturn(false);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    SearchSuggestionsState suggestionsState = const SearchSuggestionsInitial(),
    SearchHistoryState historyState = const SearchHistoryInitial(),
    SearchPopularProductsState popularProductsState =
        const SearchPopularProductsInitial(),
  }) {
    whenListen(
      suggestionsCubit,
      Stream.value(suggestionsState),
      initialState: suggestionsState,
    );
    whenListen(
      historyCubit,
      Stream.value(historyState),
      initialState: historyState,
    );
    whenListen(
      popularProductsCubit,
      Stream.value(popularProductsState),
      initialState: popularProductsState,
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<SearchSuggestionsCubit>.value(value: suggestionsCubit),
        BlocProvider<SearchHistoryCubit>.value(value: historyCubit),
        BlocProvider<SearchPopularProductsCubit>.value(
          value: popularProductsCubit,
        ),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: [], provider: routerProvider),
        child: const SearchPage(),
      ),
    );
  }

  testWidgets('renders text field and initial widget by default', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.byType(SearchTextFieldWidget), findsOneWidget);
    expect(find.byType(SearchSuggestionsInitialWidget), findsOneWidget);
  });

  testWidgets('renders loading widget when suggestions loading', (
    tester,
  ) async {
    await pumpApp(tester, suggestionsState: const SearchSuggestionsLoading());
    await tester.pumpAndSettle();

    expect(find.byType(SearchSuggestionsLoadingWidget), findsOneWidget);
  });

  testWidgets('renders loaded widget when suggestions available', (
    tester,
  ) async {
    await pumpApp(
      tester,
      suggestionsState: const SearchSuggestionsLoaded(['Case']),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchSuggestionsLoadedWidget), findsOneWidget);
    expect(find.text('Case'), findsOneWidget);
  });

  testWidgets('renders loaded search history widget when history available', (
    tester,
  ) async {
    await pumpApp(
      tester,
      historyState: const SearchHistoryLoaded(['History']),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchHistoryLoadedWidget), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

  testWidgets(
    'renders loaded popular products widget when popular products available',
    (
      tester,
    ) async {
      await pumpApp(
        tester,
        popularProductsState: const SearchPopularProductsLoaded([
          Product(
            id: 1,
            title: 'Product 1',
            thumbnail: 'thumbnail1.png',
            price: 10.0,
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchPopularProductsLoadedWidget), findsOneWidget);
      expect(find.text('Product 1'), findsOneWidget);
    },
  );
}
