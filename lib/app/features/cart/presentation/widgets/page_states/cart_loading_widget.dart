import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';
import '../cart_summary_loading_widget.dart';

class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppTopNavigationBar(title: 'cart.title'.tr(), showLeading: false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const Padding(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CartSummaryLoadingWidget(),
            ShimmerPlaceHolderWidget(
              width: double.infinity,
              height: 50,
              borderRadius: 10,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 30, bottom: 100),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 35),
          itemBuilder: (context, index) => const SizedBox(
            height: 87,
            child: Row(
              children: [
                ShimmerPlaceHolderWidget(
                  width: 87,
                  height: 87,
                  borderRadius: 10,
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    ShimmerPlaceHolderWidget(
                      width: 150,
                      height: 14,
                    ),
                    SizedBox(height: 8),
                    ShimmerPlaceHolderWidget(width: 100, height: 12),
                    Spacer(),
                    Row(
                      children: [
                        ShimmerPlaceHolderWidget(
                          width: 30,
                          height: 30,
                          borderRadius: 6,
                        ),
                        SizedBox(width: 16),
                        ShimmerPlaceHolderWidget(
                          width: 18,
                          height: 30,
                        ),
                        SizedBox(width: 16),
                        ShimmerPlaceHolderWidget(
                          width: 30,
                          height: 30,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
