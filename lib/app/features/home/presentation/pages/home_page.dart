import 'package:easy_localization/easy_localization.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/bloc/app_cubit.dart';
import '../../../../shared/extensions/layout_extension.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar_sliver.dart';
import '../../../search/infra/routes/search_route.dart';
import '../bloc/home_cubit.dart';
import '../widgets/page_states/home_failure_widget.dart';
import '../widgets/page_states/home_loaded_widget.dart';
import '../widgets/page_states/home_loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            AppColors.gray300,
            AppColors.gray300,
          ],
          stops: [0.0, 0.5, 0.6, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            AppTopNavigationBarSliver(
              expandedHeight: 190,
              scrollController: _scrollController,
              showLogo: true,
              showLeading: false,
              actions: [
                AppBarChangeableAction(
                  icon: 'search',
                  onPressed: () => context.router.push(const SearchRoute()),
                  isChangeable: false,
                ),
              ],
              flexibleSpace: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      final visitorName = 'home.visitor'.tr();
                      var userName = visitorName;

                      if (state is AppUserRefreshed) {
                        userName =
                            state.credentials?.name.split(' ').first ??
                            visitorName;
                      }

                      return Text(
                        'home.greeting'.tr(namedArgs: {'name': userName}),
                        style: context.bodyLarge,
                      );
                    },
                  ),
                  Text('home.search_prompt'.tr(), style: context.titleLarge),
                ],
              ),
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
                padding: EdgeInsets.only(
                  top: 32,
                  bottom: context.bottomBarOffset,
                ),
                sliver: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeFailure) {
                      return HomeFailureWidget(
                        error: state.exception,
                        onRetry: () => context.read<HomeCubit>().getProducts(),
                      );
                    }

                    return SliverAnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state is HomeLoaded
                          ? HomeLoadedWidget(productLists: state.productLists)
                          : const HomeLoadingWidget(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
