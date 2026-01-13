import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../product/domain/entities/product.dart';
import '../../domain/entities/product_filters.dart';
import '../../domain/repositories/catalog_repository.dart';

part 'catalog_event.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CatalogBloc extends Bloc<CatalogEvent, PagingState<int, Product>> {
  CatalogBloc(this._catalogRepository) : super(PagingState()) {
    on<CatalogGetProducts>(
      _getProducts,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final CatalogRepository _catalogRepository;

  int _skip = 0;
  final int _limit = 6;

  Future<void> _getProducts(
    CatalogGetProducts event,
    Emitter<PagingState<int, Product>> emit,
  ) async {
    if (event.reset) {
      _skip = 0;
      emit(PagingState(isLoading: true));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    final response = await _catalogRepository
        .getProducts(_limit, _skip, event.searchTerm, event.filters)
        .run();

    response.fold(
      (exception) {
        emit(state.copyWith(error: exception, isLoading: false));
      },
      (productsPage) {
        _skip += _limit;

        final newKey = (state.keys?.last ?? 0) + 1;
        final newItems = productsPage.products;
        final isLastPage = newItems.isEmpty;

        emit(
          state.copyWith(
            pages: [...?state.pages, newItems],
            keys: [...?state.keys, newKey],
            hasNextPage: !isLastPage,
            isLoading: false,
          ),
        );
      },
    );
  }
}
