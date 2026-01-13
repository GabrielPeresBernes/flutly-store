import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../../search/infra/routes/search_route.dart';
import '../bloc/product/product_cubit.dart';
import '../widgets/page_states/product_failure_widget.dart';
import '../widgets/page_states/product_loaded_widget.dart';
import '../widgets/page_states/product_loading_widget.dart';
import '../widgets/product_image_carousel_widget.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({
    super.key,
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.tag,
  });

  final int id;
  final String title;
  final String thumbnail;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();

    return Scaffold(
      extendBody: true,
      appBar: AppTopNavigationBar(
        title: title,
        actions: [
          AppBarAction(
            icon: 'search',
            onPressed: () => context.router.push(const SearchRoute()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Hero(
              tag: 'product_$tag',
              flightShuttleBuilder:
                  (_, __, flightDirection, ___, toHeroContext) {
                    // Cancel the pop animation hero flight
                    return flightDirection == HeroFlightDirection.pop
                        ? const SizedBox()
                        : toHeroContext.widget;
                  },
              child: ProductImageCarouselWidget(
                cubit: cubit,
                thumbnail: thumbnail,
              ),
            ),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: switch (state) {
                    ProductLoading() ||
                    ProductInitial() => const ProductLoadingWidget(),

                    ProductFailure(:final exception) => ProductFailureWidget(
                      exception: exception,
                      id: id,
                    ),

                    ProductLoaded(:final product) => ProductLoadedWidget(
                      product: product,
                    ),
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
