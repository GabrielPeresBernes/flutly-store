import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutly_store/app/shared/constants/bottom_navigator_tabs.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutly_store/app/shared/utils/platform_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockPackageInfo extends Mock implements PackageInfo {}

class MockLocalPlatform extends Mock implements LocalPlatform {}

void main() {
  late AuthRepository authRepository;
  late PackageInfo packageInfo;
  late LocalPlatform localPlatform;
  late PlatformUtils platformUtils;

  const credentials = Credentials(
    userId: '1',
    name: 'User',
    email: 'user@test.com',
    provider: AuthProvider.email,
  );

  setUp(() {
    authRepository = MockAuthRepository();
    packageInfo = MockPackageInfo();
    localPlatform = MockLocalPlatform();
    platformUtils = PlatformUtils(
      localPlatform: localPlatform,
      packageInfo: packageInfo,
    );

    when(() => packageInfo.version).thenReturn('1.2.3');
    when(() => packageInfo.buildNumber).thenReturn('42');
  });

  test('appFullVersion returns injected version', () {
    final cubit = AppCubit(authRepository, platformUtils: platformUtils);

    expect(cubit.appFullVersion, '1.2.3 (42)');
  });

  blocTest<AppCubit, AppState>(
    'navigateToTab emits navigation state',
    build: () => AppCubit(authRepository, platformUtils: platformUtils),
    act: (cubit) => cubit.navigateToTab(BottomNavigatorTab.home),
    expect: () => [
      isA<AppNavigateToTab>().having(
        (state) => state.tab,
        'tab',
        BottomNavigatorTab.home,
      ),
    ],
  );

  blocTest<AppCubit, AppState>(
    'refreshUser emits refreshed and updates isUserAuthenticated',
    build: () {
      when(() => authRepository.getCredentials()).thenReturn(
        TaskEither.right(const Option.of(credentials)),
      );
      return AppCubit(authRepository, platformUtils: platformUtils);
    },
    act: (cubit) async {
      await cubit.refreshUser();
      expect(cubit.isUserAuthenticated, isTrue);
    },
    expect: () => [
      isA<AppUserRefreshing>(),
      isA<AppUserRefreshed>()
          .having((state) => state.credentials, 'credentials', credentials)
          .having((state) => state.hasChanged, 'hasChanged', isFalse),
    ],
  );

  blocTest<AppCubit, AppState>(
    'refreshUser detects session change on second refresh',
    build: () {
      when(() => authRepository.getCredentials()).thenReturn(
        TaskEither.right(const Option.of(credentials)),
      );
      return AppCubit(authRepository, platformUtils: platformUtils);
    },
    act: (cubit) async {
      await cubit.refreshUser();
      when(() => authRepository.getCredentials()).thenReturn(
        TaskEither.right(none()),
      );
      await cubit.refreshUser();
    },
    expect: () => [
      isA<AppUserRefreshing>(),
      isA<AppUserRefreshed>().having(
        (state) => state.credentials,
        'credentials',
        credentials,
      ),
      isA<AppUserRefreshing>(),
      isA<AppUserRefreshed>().having(
        (state) => state.hasChanged,
        'hasChanged',
        isTrue,
      ),
    ],
  );

  blocTest<AppCubit, AppState>(
    'refreshUser does nothing when already refreshing',
    build: () => AppCubit(authRepository, platformUtils: platformUtils),
    seed: () => const AppUserRefreshing(),
    act: (cubit) => cubit.refreshUser(),
    expect: () => <AppState>[],
  );

  blocTest<AppCubit, AppState>(
    'signOut emits refreshed on success and updates flag',
    build: () {
      when(() => authRepository.signOut()).thenReturn(TaskEither.right(null));
      return AppCubit(authRepository, platformUtils: platformUtils);
    },
    act: (cubit) async {
      await cubit.signOut();
      expect(cubit.isUserAuthenticated, isFalse);
    },
    expect: () => [
      isA<AppUserRefreshing>(),
      isA<AppUserRefreshed>()
          .having((state) => state.credentials, 'credentials', isNull)
          .having((state) => state.hasChanged, 'hasChanged', isTrue),
    ],
  );

  blocTest<AppCubit, AppState>(
    'signOut emits failure on error',
    build: () {
      when(() => authRepository.signOut()).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return AppCubit(authRepository, platformUtils: platformUtils);
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [
      isA<AppUserRefreshing>(),
      isA<AppUserRefreshingFailure>(),
    ],
  );

  blocTest<AppCubit, AppState>(
    'signOut does nothing when already refreshing',
    build: () => AppCubit(authRepository, platformUtils: platformUtils),
    seed: () => const AppUserRefreshing(),
    act: (cubit) => cubit.signOut(),
    expect: () => <AppState>[],
  );
}
