import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/mock_localization_asset_loader.dart';

class TestUtils {
  static Future<void> setUpLocalization() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  }

  static Future<void> pumpApp(
    WidgetTester tester, {
    List<BlocProvider> providers = const [],
    required Widget child,
  }) => tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      assetLoader: MockLocalizationAssetLoader(),
      child: Builder(
        builder: (context) {
          final app = MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: child,
          );

          if (providers.isEmpty) {
            return app;
          }

          return MultiBlocProvider(
            providers: providers,
            child: app,
          );
        },
      ),
    ),
  );
}
