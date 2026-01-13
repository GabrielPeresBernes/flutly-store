import 'package:flutter/material.dart';
import 'navigation_bars/app_bottom_navigation_bar.dart';

final rootScaffoldKey = GlobalKey<ScaffoldState>();

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.navigateToBranch,
  });

  final Widget body;
  final int currentIndex;
  final void Function(int index) navigateToBranch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rootScaffoldKey,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: body,
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: navigateToBranch,
      ),
    );
  }
}
