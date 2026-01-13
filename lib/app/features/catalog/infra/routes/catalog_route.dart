import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/catalog_bloc.dart';
import '../../presentation/bloc/catalog_filters_cubit.dart';
import '../../presentation/pages/catalog_page.dart';
import 'catalog_route_params.dart';

class CatalogRoute extends CoreRoute<CatalogRouteParams> {
  const CatalogRoute();

  @override
  CatalogRouteParams? paramsDecoder(Map<String, dynamic> json) =>
      CatalogRouteParams.fromJson(json);

  @override
  String get path => '/catalog';

  @override
  Widget builder(BuildContext context, _) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CoreInjector.instance.get<CatalogBloc>(),
      ),
      BlocProvider(
        create: (context) => CoreInjector.instance.get<CatalogFiltersCubit>(),
      ),
    ],
    child: const CatalogPage(),
  );
}
