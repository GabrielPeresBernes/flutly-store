import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'animated_indexed_stack.dart';

class IndexedStackedRouteBranchContainer extends StatelessWidget {
  const IndexedStackedRouteBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  Widget _buildRouteBranchContainer(
    BuildContext context,
    bool isActive,
    Widget child,
  ) => Offstage(
    offstage: !isActive,
    child: TickerMode(enabled: isActive, child: child),
  );

  @override
  Widget build(BuildContext context) {
    final stackItems = children
        .mapIndexed(
          (int index, Widget child) => _buildRouteBranchContainer(
            context,
            currentIndex == index,
            child,
          ),
        )
        .toList();

    return Container(
      color: Colors.white,
      child: AnimatedIndexedStack(index: currentIndex, children: stackItems),
    );
  }
}
