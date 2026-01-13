import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/cart_popular_products_cubit.dart';
import '../../presentation/pages/cart_page.dart';

class CartRoute extends CoreRoute {
  const CartRoute();

  @override
  String get path => '/cart';

  @override
  Widget builder(BuildContext context, _) => BlocProvider(
    create: (context) => CoreInjector.instance.get<CartPopularProductsCubit>(),
    child: const CartPage(),
  );
}
