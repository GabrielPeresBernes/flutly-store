import 'package:flutter/material.dart';

import '../../../core/router/router.dart';
import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';
import '../logo_widget.dart';

class AppBarChangeableAction {
  AppBarChangeableAction({
    required this.onPressed,
    this.icon,
    this.widget,
    this.isChangeable = true,
  });

  final VoidCallback onPressed;
  final String? icon;
  final Widget? widget;
  final bool isChangeable;
}

class AppTopNavigationBarSliver extends StatefulWidget {
  const AppTopNavigationBarSliver({
    super.key,
    required this.scrollController,
    required this.expandedHeight,
    required this.flexibleSpace,
    this.title,
    this.showLeading = true,
    this.showLogo = false,
    this.scrollOffsetVisibleThreshold,
    this.actions = const [],
  });

  final ScrollController scrollController;
  final double expandedHeight;
  final String? title;
  final Widget flexibleSpace;
  final bool showLeading;
  final bool showLogo;
  final double? scrollOffsetVisibleThreshold;
  final List<AppBarChangeableAction> actions;

  @override
  State<AppTopNavigationBarSliver> createState() =>
      _AppTopNavigationBarSliverState();
}

class _AppTopNavigationBarSliverState extends State<AppTopNavigationBarSliver> {
  bool _visible = false;

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset >=
          (widget.scrollOffsetVisibleThreshold ?? widget.expandedHeight) -
              kToolbarHeight) {
        setState(() => _visible = true);
      } else {
        setState(() => _visible = false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      pinned: true,
      collapsedHeight: kToolbarHeight,
      expandedHeight: widget.expandedHeight,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      title: widget.showLogo
          ? const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: LogoWidget(),
            )
          : widget.title != null
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _visible ? 1 : 0,
              child: Text(widget.title!, style: context.labelLarge),
            )
          : null,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      actionsPadding: const EdgeInsets.only(right: 10),
      leading: widget.showLeading && context.router.canPop()
          ? IconButton(
              onPressed: context.router.pop,
              icon: const AppIconWidget.svgAsset('chevron_left', size: 24),
            )
          : null,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: kToolbarHeight,
              left: 24,
              right: 24,
            ),
            child: widget.flexibleSpace,
          ),
        ),
      ),
      actions: widget.actions.map(
        (action) {
          final isChangeable = action.isChangeable;
          final isVisible = !isChangeable || (isChangeable && _visible);

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isVisible ? 1 : 0,
            child: IconButton(
              onPressed: action.onPressed,
              icon:
                  action.widget ??
                  AppIconWidget.svgAsset(action.icon ?? '', size: 24),
            ),
          );
        },
      ).toList(),
    );
  }
}
