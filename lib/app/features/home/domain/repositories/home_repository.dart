import '../../../../shared/types/response_type.dart';
import '../entities/home_product_list.dart';

abstract interface class HomeRepository {
  TaskResponse<List<HomeProductList>> getProducts();
}
