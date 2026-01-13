import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injector/injector.dart';
import '../../../../core/router/router.dart';
import '../../presentation/bloc/profile_cubit.dart';
import '../../presentation/pages/report_bug_page.dart';

class ReportBugRoute extends CoreRoute {
  const ReportBugRoute();

  @override
  String get path => '/report-bug';

  @override
  Widget builder(BuildContext context, _) => BlocProvider(
    create: (context) => CoreInjector.instance.get<ProfileCubit>(),
    child: const ReportBugPage(),
  );
}
