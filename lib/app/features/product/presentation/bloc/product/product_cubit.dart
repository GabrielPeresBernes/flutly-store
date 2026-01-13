import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../domain/entities/product_extended.dart';
import '../../../domain/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(
    this._productRepository,
  ) : super(const ProductInitial());

  final ProductRepository _productRepository;

  final instanceId = DateTime.now().microsecondsSinceEpoch;

  Future<void> getProductById(int? id) async {
    if (id == null) {
      emit(
        ProductFailure(
          exception: AppException(message: 'product.errors.id_null'.tr()),
        ),
      );
      return;
    }

    final delay = Future<void>.delayed(const Duration(milliseconds: 300));

    emit(const ProductLoading());

    final response = await _productRepository.getProductById(id).run();

    await delay;

    response.fold(
      (exception) => emit(ProductFailure(exception: exception)),
      (product) => emit(ProductLoaded(product: product)),
    );
  }
}
