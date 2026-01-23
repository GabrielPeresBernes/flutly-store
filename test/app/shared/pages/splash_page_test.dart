import 'package:flutly_store/app/shared/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders splash logo and background image', (tester) async {
    await tester.pumpWidget(const SplashPage());

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).image?.image is AssetImage &&
            ((widget.decoration! as BoxDecoration).image!.image as AssetImage)
                    .assetName ==
                'assets/images/auth_background.png',
      ),
      findsOneWidget,
    );
  });

  testWidgets('background fades in after first frame', (tester) async {
    await tester.pumpWidget(const SplashPage());

    final initialOpacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(initialOpacity.opacity, 0.0);

    await tester.pump();

    final updatedOpacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(updatedOpacity.opacity, 1.0);
  });
}
