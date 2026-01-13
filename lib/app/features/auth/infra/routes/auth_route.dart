import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/auth_cubit.dart';
import '../../presentation/pages/sign_in_page.dart';

class AuthRoute extends CoreRoute {
  const AuthRoute();

  @override
  String get path => '/auth';

  @override
  Widget builder(BuildContext context, _) => BlocProvider(
    create: (context) => CoreInjector.instance.get<AuthCubit>(),
    child: const SignInPage(),
  );
}
