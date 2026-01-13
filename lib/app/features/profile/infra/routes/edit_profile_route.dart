import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/profile_cubit.dart';
import '../../presentation/pages/edit_profile_page.dart';

class EditProfileRoute extends CoreRoute {
  const EditProfileRoute();

  @override
  String get path => '/edit-profile';

  @override
  Widget builder(BuildContext context, _) => BlocProvider(
    create: (context) =>
        CoreInjector.instance.get<ProfileCubit>()..getUserData(),
    child: const EditProfilePage(),
  );
}
