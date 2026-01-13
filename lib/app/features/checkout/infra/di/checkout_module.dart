// ignore_for_file: cascade_invocations

import '../../../../core/injector/injector.dart';
import '../../presentation/bloc/checkout/checkout_cubit.dart';
import '../../presentation/bloc/checkout_address/checkout_address_cubit.dart';
import '../../presentation/bloc/checkout_navigation/checkout_navigation_cubit.dart';
import '../../presentation/bloc/checkout_payment/checkout_payment_cubit.dart';
import '../../presentation/bloc/checkout_shipping/checkout_shipping_cubit.dart';

class CheckoutModule extends InjectorModule {
  const CheckoutModule();

  @override
  Future<void> register(CoreInjector injector) async {
    injector.registerFactory<CheckoutNavigationCubit>(
      CheckoutNavigationCubit.new,
    );

    injector.registerFactory<CheckoutCubit>(CheckoutCubit.new);

    injector.registerFactory<CheckoutAddressCubit>(CheckoutAddressCubit.new);

    injector.registerFactory<CheckoutShippingCubit>(CheckoutShippingCubit.new);

    injector.registerFactory<CheckoutPaymentCubit>(CheckoutPaymentCubit.new);
  }
}
