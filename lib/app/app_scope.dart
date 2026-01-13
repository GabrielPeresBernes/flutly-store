import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injector/injector.dart';
import 'core/router/router.dart';
import 'features/cart/cart.dart';
import 'features/home/home.dart';
import 'features/profile/profile.dart';
import 'shared/bloc/app_cubit.dart';
import 'shared/constants/bottom_navigator_tabs.dart';
import 'shared/extensions/show_app_snack_bar_extension.dart';
import 'shared/widgets/demo_banner_widget.dart';
import 'shared/widgets/keyboard_dismissible_widget.dart';

class AppScope extends StatelessWidget {
  const AppScope({super.key, required this.child});

  final Widget? child;

  void _handleTabNavigation(BuildContext context, AppNavigateToTab state) {
    switch (state.tab) {
      case BottomNavigatorTab.home:
        context.router.go(const HomeRoute());
        return;
      case BottomNavigatorTab.cart:
        context.router.go(const CartRoute());
        return;
      case BottomNavigatorTab.profile:
        context.router.go(const ProfileRoute());
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<AppCubit>()..refreshUser(),
        ),
        BlocProvider(
          create: (context) => CoreInjector.instance.get<CartCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppCubit, AppState>(
            listener: (context, state) {
              if (state is AppNavigateToTab) {
                return _handleTabNavigation(context, state);
              }

              if (state is AppUserRefreshingFailure) {
                return context.showAppSnackBar(
                  message: state.exception.message,
                  type: SnackBarType.error,
                );
              }

              if (state is AppUserRefreshed) {
                context.read<CartCubit>().refreshCart(
                  hasSessionChanged: state.hasChanged,
                );

                if (state.credentials == null && state.hasChanged) {
                  context.showAppSnackBar(
                    message: 'profile.messages.signed_out'.tr(),
                    type: SnackBarType.info,
                  );
                }
              }
            },
          ),
          BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartLoaded && state.hasUpdated) {
                context.showAppSnackBar(
                  message: 'Your cart has been updated',
                  type: SnackBarType.info,
                );
              }
            },
          ),
        ],
        child: DemoBannerWidget(
          child: KeyboardDismissibleWidget(
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
