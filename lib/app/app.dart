import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'core/injector/injector.dart';
import 'core/router/router.dart';
import 'shared/infra/di/app_module.dart';
import 'shared/infra/routes/app_router.dart';
import 'shared/pages/splash_page.dart';
import 'shared/pages/startup_failure_page.dart';
import 'shared/theme/theme_data.dart';
import 'shared/utils/multiple_localization_asset_loaded.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<void> _injectionFuture;

  @override
  void initState() {
    super.initState();

    _injectionFuture = AppModule().register(CoreInjector.instance);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _injectionFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return StartupFailurePage(
            error: snapshot.error,
            stacktrace: snapshot.stackTrace,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashPage();
        }

        return EasyLocalization(
          supportedLocales: const [Locale('en')],
          fallbackLocale: const Locale('en'),
          path: 'assets/translations',
          assetLoader: const MultipleLocalizationAssetLoader(),
          child: CoreRouterScope(
            coreRouter: appRouter,
            child: Builder(
              builder: (context) => MaterialApp.router(
                title: 'Flutly Store',
                theme: themeData,
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter.router.routerConfig,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  physics: Platform.isIOS
                      ? const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        )
                      : null,
                ),
                builder: (_, child) => AppScope(child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}
