import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../features/auth/auth.dart';
import '../constants/bottom_navigator_tabs.dart';
import '../errors/app_exception.dart';
import '../utils/platform_utils.dart';

part 'app_state.dart';

/// Global application cubit for managing app state
class AppCubit extends Cubit<AppState> {
  AppCubit(
    this._authRepository, {
    PlatformUtils? platformUtils,
  }) : _platformUtils = platformUtils ?? PlatformUtils(),
       super(const AppInitial());

  final AuthRepository _authRepository;
  final PlatformUtils _platformUtils;

  String get appFullVersion => _platformUtils.fullAppVersion;

  bool? _isUserAuthenticated;

  bool get isUserAuthenticated => _isUserAuthenticated ?? false;

  /// Navigates to the specified bottom navigator tab
  Future<void> navigateToTab(
    BottomNavigatorTab tab, {
    bool shouldReset = false,
  }) async {
    emit(AppNavigateToTab(tab, shouldReset: shouldReset));
  }

  /// Refreshes the current user's credentials
  Future<void> refreshUser() async {
    if (state is AppUserRefreshing) {
      return;
    }

    emit(const AppUserRefreshing());

    final response = await _authRepository.getCredentials().run();

    final credentials = response.getOrElse((e) => const None()).toNullable();

    emit(
      AppUserRefreshed(
        credentials: credentials,
        hasChanged: _hasSessionChanged(credentials),
      ),
    );

    _isUserAuthenticated = credentials != null;
  }

  Future<void> signOut() async {
    if (state is AppUserRefreshing) {
      return;
    }

    emit(const AppUserRefreshing());

    final response = await _authRepository.signOut().run();

    response.fold(
      (exception) => emit(AppUserRefreshingFailure(exception: exception)),
      (_) => emit(const AppUserRefreshed(credentials: null, hasChanged: true)),
    );

    _isUserAuthenticated = false;
  }

  bool _hasSessionChanged(Credentials? credentials) {
    if (_isUserAuthenticated == null) {
      return false;
    }

    return _isUserAuthenticated != (credentials != null);
  }
}
