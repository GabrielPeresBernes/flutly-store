import 'package:easy_localization/easy_localization.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/extensions/layout_extension.dart';
import '../../../../shared/extensions/show_app_bottom_sheet_extension.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/utils/string_utils.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar_sliver.dart';
import '../../../../shared/widgets/products/medium_product_card_widget.dart';
import '../../../product/domain/entities/product.dart';
import '../../../search/infra/routes/search_route.dart';
import '../../infra/routes/catalog_route_params.dart';
import '../../utils/catalog_utils.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_filters_cubit.dart';
import '../widgets/filters_bottom_sheet_widget.dart';
import '../widgets/filters_button_widget.dart';
import '../widgets/page_states/catalog_empty_widget.dart';
import '../widgets/page_states/catalog_initial_error_widget.dart';
import '../widgets/page_states/catalog_initial_loading_widget.dart';
import '../widgets/page_states/catalog_new_page_error_widget.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogBloc = context.read<CatalogBloc>();
    final filtersCubit = context.read<CatalogFiltersCubit>();

    final params = context.router.getParams<CatalogRouteParams>();

    final catalogUtils = CatalogUtils(context);

    return BlocListener<CatalogFiltersCubit, CatalogFiltersState>(
      listener: (context, state) {
        _scrollController.jumpTo(0);
        catalogBloc.add(
          CatalogGetProducts(
            searchTerm: params?.term,
            filters: state.filters,
            reset: true,
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.white,
              AppColors.gray300,
              AppColors.gray300,
            ],
            stops: [0.0, 0.6, 0.6, 1.0],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              BlocBuilder<CatalogFiltersCubit, CatalogFiltersState>(
                builder: (context, state) {
                  return AppTopNavigationBarSliver(
                    expandedHeight: 186,
                    scrollController: _scrollController,
                    title: params != null && params.term.isNotEmpty
                        ? StringUtils.capitalize(params.term)
                        : 'catalog.title'.tr(),
                    scrollOffsetVisibleThreshold: 172,
                    actions: [
                      AppBarChangeableAction(
                        widget: Badge(
                          isLabelVisible: filtersCubit.appliedFiltersCount > 0,
                          label: Text('${filtersCubit.appliedFiltersCount}'),
                          child: const AppIconWidget.svgAsset(
                            'sliders',
                            size: 24,
                          ),
                        ),
                        onPressed: () => context.showAppBottomSheet(
                          child: FiltersBottomSheetWidget(
                            cubit: filtersCubit,
                          ),
                        ),
                      ),
                      AppBarChangeableAction(
                        icon: 'search',
                        onPressed: () =>
                            context.router.push(const SearchRoute()),
                        isChangeable: false,
                      ),
                    ],
                    flexibleSpace: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          params != null && params.term.isNotEmpty
                              ? StringUtils.capitalize(params.term)
                              : 'catalog.title'.tr(),
                          style: context.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        const FiltersButtonWidget(),
                      ],
                    ),
                  );
                },
              ),
              DecoratedSliver(
                decoration: ShapeDecoration(
                  color: AppColors.gray300,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 24,
                      cornerSmoothing: .5,
                    ),
                  ),
                ),
                sliver: SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    context.bottomBarOffset,
                  ),
                  sliver: BlocBuilder<CatalogBloc, PagingState<int, Product>>(
                    builder: (context, state) {
                      return PagedSliverGrid<int, Product>(
                        state: state,
                        showNewPageErrorIndicatorAsGridChild: false,
                        showNewPageProgressIndicatorAsGridChild: false,
                        fetchNextPage: () => catalogBloc.add(
                          CatalogGetProducts(
                            searchTerm: params?.term,
                            filters: filtersCubit.state.filters,
                          ),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: catalogUtils.nProductsPerRow,
                          mainAxisSpacing: catalogUtils.axisSpacing,
                          crossAxisSpacing: catalogUtils.axisSpacing,
                          childAspectRatio: catalogUtils.productsAspectRatio,
                        ),
                        builderDelegate: PagedChildBuilderDelegate(
                          animateTransitions: true,
                          transitionDuration: const Duration(milliseconds: 300),
                          newPageProgressIndicatorBuilder: (context) =>
                              const SizedBox.shrink(),
                          newPageErrorIndicatorBuilder: (context) =>
                              const CatalogNewPageErrorWidget(),
                          firstPageErrorIndicatorBuilder: (_) =>
                              const CatalogInitialErrorWidget(),
                          firstPageProgressIndicatorBuilder: (_) =>
                              const CatalogInitialLoadingWidget(),
                          noItemsFoundIndicatorBuilder: (_) =>
                              const CatalogEmptyWidget(),
                          itemBuilder: (context, item, index) =>
                              MediumProductCardWidget(
                                image: item.thumbnail,
                                title: item.title,
                                price: item.price,
                                rating: item.rating,
                                id: item.id,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
