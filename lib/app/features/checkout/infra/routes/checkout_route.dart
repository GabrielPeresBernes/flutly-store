import 'package:flutter/material.dart';

import '../../../../core/router/router.dart';
import '../../presentation/pages/checkout_confirmation_page.dart';
import 'checkout_route_params.dart';

class CheckoutRoute extends CoreRoute<CheckoutRouteParams> {
  const CheckoutRoute();

  @override
  CheckoutRouteParams? paramsDecoder(Map<String, dynamic> json) =>
      CheckoutRouteParams.fromJson(json);

  @override
  String get path => '/checkout';

  @override
  Widget builder(BuildContext context, CheckoutRouteParams? params) {
    return const CheckoutConfirmationPage();
  }
}
