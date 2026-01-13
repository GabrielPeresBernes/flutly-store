import 'package:flutter/material.dart';

import '../../../core/router/router.dart';
import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';
import '../logo_widget.dart';

class AppBarAction {
  AppBarAction({
    required this.icon,
    required this.onPressed,
    this.color = AppColors.black,
  });

  final String icon;
  final VoidCallback onPressed;
  final Color color;
}

class AppTopNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AppTopNavigationBar({
    super.key,
    this.showLeading = true,
    this.showLogo = false,
    this.color = AppColors.white,
    this.title,
    this.actions = const [],
  });

  final bool showLeading;
  final bool showLogo;
  final String? title;
  final List<AppBarAction> actions;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: color,
      surfaceTintColor: color,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      actionsPadding: const EdgeInsets.only(right: 10),
      leading: showLeading && context.router.canPop()
          ? IconButton(
              onPressed: context.router.pop,
              icon: const AppIconWidget.svgAsset('chevron_left', size: 24),
            )
          : null,
      automaticallyImplyLeading: false,
      title: showLogo
          ? const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: LogoWidget(),
            )
          : title != null
          ? Text(title!, style: context.labelLarge)
          : null,
      actions: actions
          .map(
            (action) => IconButton(
              onPressed: action.onPressed,
              icon: AppIconWidget.svgAsset(
                action.icon,
                size: 24,
                color: action.color,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
