import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route.dart';
import 'package:flutly_store/app/features/catalog/infra/routes/catalog_route_params.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/history/search_history_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/bloc/suggestions/search_suggestions_cubit.dart';
import 'package:flutly_store/app/features/search/presentation/widgets/search_text_field_widget.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockSearchSuggestionsCubit extends MockCubit<SearchSuggestionsState>
    implements SearchSuggestionsCubit {}

class MockSearchHistoryCubit extends MockCubit<SearchHistoryState>
    implements SearchHistoryCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late SearchSuggestionsCubit suggestionsCubit;
  late SearchHistoryCubit historyCubit;
  late RouterProvider routerProvider;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(const CatalogRoute());
    registerFallbackValue(const CatalogRouteParams(term: ''));
  });

  setUp(() {
    suggestionsCubit = MockSearchSuggestionsCubit();
    historyCubit = MockSearchHistoryCubit();
    routerProvider = MockRouterProvider();

    when(() => suggestionsCubit.state).thenReturn(
      const SearchSuggestionsInitial(),
    );
    when(() => historyCubit.state).thenReturn(const SearchHistoryInitial());
    when(() => suggestionsCubit.getSuggestions(any())).thenAnswer((_) async {});
    when(() => historyCubit.saveSearchTerm(any())).thenAnswer((_) async {});
    when(
      () => routerProvider.push(
        any(),
        params: any(named: 'params'),
      ),
    ).thenAnswer((_) {});
  });

  Future<void> pumpApp(WidgetTester tester) {
    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<SearchSuggestionsCubit>.value(value: suggestionsCubit),
        BlocProvider<SearchHistoryCubit>.value(value: historyCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const Material(child: SearchTextFieldWidget()),
      ),
    );
  }

  testWidgets('typing triggers suggestions and shows clear icon', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
      ),
      findsNothing,
    );

    await tester.enterText(find.byType(TextField), 'shoe');
    await tester.pump();

    verify(() => suggestionsCubit.getSuggestions('shoe')).called(1);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
      ),
      findsOneWidget,
    );
  });

  testWidgets('submitting saves term and pushes catalog route', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'sneakers');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(() => historyCubit.saveSearchTerm('Sneakers')).called(1);
    verify(
      () => routerProvider.push(
        const CatalogRoute(),
        params: const CatalogRouteParams(term: 'sneakers'),
      ),
    ).called(1);
  });

  testWidgets('clear button clears text and resets suggestions', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'case');
    await tester.pump();

    final closeIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
    );
    await tester.tap(
      find.ancestor(of: closeIcon, matching: find.byType(GestureDetector)),
    );
    await tester.pump();

    verify(() => suggestionsCubit.getSuggestions('')).called(1);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '',
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
      ),
      findsNothing,
    );
  });
}
