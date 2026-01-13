import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../domain/entities/home_product_list.dart';
import '../../domain/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepository) : super(const HomeInitial());

  final HomeRepository _homeRepository;

  Future<void> getProducts() async {
    emit(const HomeLoading());

    final response = await _homeRepository.getProducts().run();

    response.fold(
      (exception) => emit(HomeFailure(exception: exception)),
      (productLists) => emit(HomeLoaded(productLists: productLists)),
    );
  }
}
