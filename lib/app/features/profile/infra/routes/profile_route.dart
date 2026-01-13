import 'package:flutter/widgets.dart';

import '../../../../core/router/router.dart';
import '../../presentation/pages/profile_page.dart';

class ProfileRoute extends CoreRoute {
  const ProfileRoute();

  @override
  String get path => '/profile';

  @override
  Widget builder(BuildContext context, _) => const ProfilePage();
}
