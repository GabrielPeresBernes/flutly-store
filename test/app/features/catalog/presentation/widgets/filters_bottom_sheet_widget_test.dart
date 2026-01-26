import 'package:flutly_store/app/features/catalog/presentation/bloc/filters/catalog_filters_cubit.dart';
import 'package:flutly_store/app/features/catalog/presentation/widgets/filters_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockCatalogFiltersCubit extends Mock implements CatalogFiltersCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late CatalogFiltersCubit cubit;
  late NavigatorObserver navigatorObserver;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    cubit = MockCatalogFiltersCubit();
    navigatorObserver = MockNavigatorObserver();

    when(() => cubit.selectedSortOption).thenReturn(SortOption.unsorted);
    when(() => cubit.minPrice).thenReturn('');
    when(() => cubit.maxPrice).thenReturn('');
    when(
      () => cubit.applyFilters(
        minPrice: any(named: 'minPrice'),
        maxPrice: any(named: 'maxPrice'),
        selectedSortOption: any(named: 'selectedSortOption'),
      ),
    ).thenAnswer((_) async {});
    when(() => cubit.clearFilters()).thenAnswer((_) async {});
  });

  Future<void> pumpApp(WidgetTester tester) => TestUtils.pumpApp(
    tester,
    child: Navigator(
      observers: [navigatorObserver],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => Material(
          child: FiltersBottomSheetWidget(cubit: cubit),
        ),
      ),
    ),
  );

  testWidgets('renders labels, inputs, and choices', (tester) async {
    when(() => cubit.selectedSortOption).thenReturn(
      SortOption.priceLowToHigh,
    );
    when(() => cubit.minPrice).thenReturn('10');
    when(() => cubit.maxPrice).thenReturn('100');

    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Sort By'), findsOneWidget);
    expect(find.text('Price Range'), findsOneWidget);
    expect(find.text('Min Price'), findsOneWidget);
    expect(find.text('Max Price'), findsOneWidget);
    expect(find.text('Apply Filters'), findsOneWidget);
    expect(find.text('Clear Filters'), findsOneWidget);
    expect(find.text('Unsorted'), findsNothing);

    final chips = find.byType(ChoiceChip);
    expect(chips, findsNWidgets(3));

    final selectedChip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Low Price'),
    );
    expect(selectedChip.selected, isTrue);

    final fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();
    expect(fields.first.controller?.text, '10');
    expect(fields.last.controller?.text, '100');
  });

  testWidgets('applies filters and pops', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '25');
    await tester.enterText(find.byType(TextField).last, '200');
    await tester.tap(find.widgetWithText(ChoiceChip, 'High Price'));
    await tester.pump();

    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();

    verify(
      () => cubit.applyFilters(
        minPrice: '25',
        maxPrice: '200',
        selectedSortOption: SortOption.priceHighToLow,
      ),
    ).called(1);
    verify(() => navigatorObserver.didPop(any(), any())).called(1);
  });

  testWidgets('clears filters and pops', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clear Filters'));
    await tester.pumpAndSettle();

    verify(() => cubit.clearFilters()).called(1);
    verify(() => navigatorObserver.didPop(any(), any())).called(1);
  });
}
