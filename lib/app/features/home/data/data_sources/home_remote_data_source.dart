import '../../../../shared/types/response_type.dart';
import '../models/home_product_list_model.dart';

abstract interface class HomeRemoteDataSource {
  TaskResponse<List<HomeProductListModel>> getProducts();
}
