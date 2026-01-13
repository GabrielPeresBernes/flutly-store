import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/home_cubit.dart';
import '../../presentation/pages/home_page.dart';

class HomeRoute extends CoreRoute {
  const HomeRoute();

  @override
  String get path => '/';

  @override
  Widget builder(BuildContext context, _) => BlocProvider(
    create: (context) => CoreInjector.instance.get<HomeCubit>()..getProducts(),
    child: const HomePage(),
  );
}
