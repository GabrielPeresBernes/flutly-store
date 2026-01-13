import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/product/product_cubit.dart';
import '../../presentation/bloc/recommendation/product_recommendation_cubit.dart';
import '../../presentation/pages/product_page.dart';
import 'product_route_params.dart';

class ProductRoute extends CoreRoute<ProductRouteParams> {
  const ProductRoute();

  @override
  ProductRouteParams? paramsDecoder(Map<String, dynamic> json) =>
      ProductRouteParams.fromJson(json);

  @override
  String get path => '/product';

  @override
  TransitionAnimation? get transitionAnimation =>
      TransitionAnimation.sharedAxisScaled;

  @override
  Widget builder(BuildContext context, ProductRouteParams? params) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<ProductCubit>()
                ..getProductById(params?.id),
        ),
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<ProductRecommendationCubit>()
                ..getRecommendations(forProductId: params?.id),
        ),
      ],
      child: ProductPage(
        id: params?.id ?? 0,
        title: params?.title ?? '',
        thumbnail: params?.thumbnail ?? '',
        tag: params?.tag ?? '',
      ),
    );
  }
}
