part of 'app_cubit.dart';

sealed class AppState {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppNavigateToTab extends AppState {
  const AppNavigateToTab(this.tab, {this.shouldReset = false});

  final BottomNavigatorTab tab;
  final bool shouldReset;
}

class AppUserRefreshing extends AppState {
  const AppUserRefreshing();
}

class AppUserRefreshingFailure extends AppState {
  const AppUserRefreshingFailure({required this.exception});

  final AppException exception;
}

class AppUserRefreshed extends AppState {
  const AppUserRefreshed({
    required this.credentials,
    required this.hasChanged,
  });

  final Credentials? credentials;
  final bool hasChanged;
}
