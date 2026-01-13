import '../../../../shared/types/response_type.dart';
import '../../domain/entities/home_product_list.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  TaskResponse<List<HomeProductList>> getProducts() {
    return _remoteDataSource.getProducts().map(
      (productsLists) => productsLists
          .map((productListModel) => productListModel.toEntity())
          .toList(),
    );
  }
}
