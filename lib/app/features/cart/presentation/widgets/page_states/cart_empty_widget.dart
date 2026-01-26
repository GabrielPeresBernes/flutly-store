import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/bloc/app_cubit.dart';
import '../../../../../shared/constants/bottom_navigator_tabs.dart';
import '../../../../../shared/extensions/layout_extension.dart';
import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/app_icon_widget.dart';
import '../../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../bloc/popular_products/cart_popular_products_cubit.dart';
import 'popular_products_failure_widget.dart';
import 'popular_products_loaded_widget.dart';
import 'popular_products_loading_widget.dart';

class CartEmptyWidget extends StatefulWidget {
  const CartEmptyWidget({super.key});

  @override
  State<CartEmptyWidget> createState() => _CartEmptyWidgetState();
}

class _CartEmptyWidgetState extends State<CartEmptyWidget> {
  @override
  void initState() {
    context.read<CartPopularProductsCubit>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.white,
            AppColors.white,
            AppColors.gray400,
            AppColors.gray400,
          ],
          stops: [0.0, 0.5, 0.7, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppTopNavigationBar(
          title: 'cart.title'.tr(),
          showLeading: false,
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox(height: 30)),
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: AppIconWidget.svgAsset('box_empty', size: 120),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'cart.empty.title'.tr(),
                        style: context.bodyLarge,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 195,
                        child: AppElevatedButtonWidget(
                          onPressed: () =>
                              context.read<AppCubit>().navigateToTab(
                                BottomNavigatorTab.home,
                              ),
                          label: 'cart.empty.browse_products'.tr(),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          24,
                          28,
                          24,
                          context.bottomBarOffset,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.gray400,
                        ),
                        child:
                            BlocBuilder<
                              CartPopularProductsCubit,
                              CartPopularProductsState
                            >(
                              builder: (context, state) => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                child: switch (state) {
                                  CartPopularProductsLoading() ||
                                  CartPopularProductsInitial() =>
                                    const PopularProductsLoadingWidget(),
                                  CartPopularProductsLoaded(:final products) =>
                                    PopularProductsLoadedWidget(
                                      products: products,
                                    ),
                                  CartPopularProductsFailure(
                                    :final exception,
                                  ) =>
                                    PopularProductsFailureWidget(
                                      exception: exception,
                                    ),
                                },
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
