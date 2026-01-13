import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/cart/cart.dart';
import '../../constants/bottom_navigator_tabs.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: Platform.isAndroid
            ? MediaQuery.of(context).padding.bottom + 10
            : MediaQuery.of(context).padding.bottom,
      ),
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        elevation: 12,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                BottomNavigatorTab.values.length,
                (index) {
                  final isTabActive = currentIndex == index;
                  final isCartTab =
                      BottomNavigatorTab.values[index] ==
                      BottomNavigatorTab.cart;

                  return BlocBuilder<CartCubit, CartState>(
                    buildWhen: (previous, current) =>
                        current is CartLoaded ||
                        current is CartUpdated ||
                        current is CartEmpty,
                    builder: (context, state) {
                      final cartTotalItems = cartCubit.cart.totalItems;

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => onTap(index),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              alignment: Alignment.center,
                              child: Badge(
                                isLabelVisible: isCartTab && cartTotalItems > 0,
                                label: Text('$cartTotalItems'),
                                child: AppIconWidget.svgAsset(
                                  isTabActive
                                      ? BottomNavigatorTab
                                            .values[index]
                                            .activeIcon
                                      : BottomNavigatorTab.values[index].icon,
                                  size: 24,
                                  color: isTabActive
                                      ? AppColors.primary
                                      : AppColors.gray200,
                                ),
                              ),
                            ),
                            AnimatedScale(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeInOut,
                              scale: isTabActive ? 1 : 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isTabActive
                                      ? AppColors.primary.withValues(
                                          alpha: 0.1,
                                        )
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
