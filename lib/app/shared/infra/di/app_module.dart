// ignore_for_file: cascade_invocations

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/http/http.dart';
import '../../../core/injector/injector.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../features/auth/auth.dart';
import '../../../features/cart/cart.dart';
import '../../../features/catalog/catalog.dart';
import '../../../features/checkout/checkout.dart';
import '../../../features/home/home.dart';
import '../../../features/product/product.dart';
import '../../../features/profile/profile.dart';
import '../../../features/search/search.dart';
import '../../bloc/app_cubit.dart';
import '../../utils/env.dart';
import 'firebase_module.dart';

/// Application dependency injection module
class AppModule extends InjectorModule {
  AppModule();

  final modules = [
    const AuthModule(),
    const HomeModule(),
    const SearchModule(),
    const CatalogModule(),
    const CartModule(),
    const ProductModule(),
    const CheckoutModule(),
    const ProfileModule(),
  ];

  @override
  Future<void> register(CoreInjector injector) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Lock device orientation to portrait only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await EasyLocalization.ensureInitialized();

    Env.validate();

    await const FirebaseModule().register(injector);

    final sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {
          SearchConstants.searchHistoryKey,
          CartConstants.cartStorageKey,
        },
      ),
    );

    injector.registerSingleton<FlutterSecureStorage>(
      const FlutterSecureStorage(),
    );

    injector.registerSingleton<Dio>(
      Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
    );

    injector.registerSingleton<CoreHttp>(DioProvider(injector.get<Dio>()));

    injector.registerSingleton<CoreLocalStorage>(
      CoreLocalStorage(
        provider: SharedPreferencesProvider(sharedPreferences),
        encryptedProvider: SecureStorageProvider(
          injector.get<FlutterSecureStorage>(),
        ),
      ),
    );

    injector.registerSingleton<LocalPlatform>(const LocalPlatform());

    final packageInfo = await PackageInfo.fromPlatform();

    injector.registerSingleton<PackageInfo>(packageInfo);

    await _registerModules(injector);

    injector.registerSingleton<AppCubit>(
      AppCubit(injector.get<AuthRepository>()),
    );
  }

  Future<void> _registerModules(CoreInjector injector) async {
    for (final module in modules) {
      await module.register(injector);
    }
  }
}
