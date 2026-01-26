import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutly_store/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutly_store/app/features/profile/domain/entities/bug_report.dart';
import 'package:flutly_store/app/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutly_store/app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:flutly_store/app/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../utils/test_utils.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeBugReport extends Fake implements BugReport {}

void main() {
  late AuthRepository authRepository;
  late ProfileRepository profileRepository;

  const credentials = Credentials(
    userId: 'user-1',
    name: 'User',
    email: 'user@test.com',
    provider: AuthProvider.google,
  );

  const bugReport = BugReport(
    description: 'Crash on checkout',
    stepsToReproduce: ['Open cart', 'Tap checkout'],
    expectedBehavior: 'Checkout should open',
    issueType: 'Crash',
    screen: 'Cart',
    frequency: 'Always',
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(FakeBugReport());
  });

  setUp(() {
    authRepository = MockAuthRepository();
    profileRepository = MockProfileRepository();
  });

  blocTest<ProfileCubit, ProfileState>(
    'getUserData emits failure when repository fails',
    build: () {
      when(() => authRepository.getCredentials()).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) => cubit.getUserData(),
    expect: () => [
      isA<ProfileFailure>(),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'getUserData emits failure when credentials are missing',
    build: () {
      when(() => authRepository.getCredentials()).thenReturn(
        TaskEither.right(none()),
      );
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) => cubit.getUserData(),
    expect: () => [
      isA<ProfileFailure>().having(
        (state) => state.exception.message,
        'message',
        'profile.errors.load_user',
      ),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'getUserData fills form and disables password fields for social login',
    build: () {
      when(() => authRepository.getCredentials()).thenReturn(
        TaskEither.right(const Option.of(credentials)),
      );
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) => cubit.getUserData(),
    expect: () => <ProfileState>[],
    verify: (cubit) {
      expect(cubit.editProfileForm.control('name').value, 'User');
      expect(cubit.editProfileForm.control('email').value, 'user@test.com');
      expect(cubit.editProfileForm.control('currentPassword').disabled, isTrue);
      expect(cubit.editProfileForm.control('newPassword').disabled, isTrue);
      expect(
        cubit.editProfileForm.control('confirmNewPassword').disabled,
        isTrue,
      );
    },
  );

  blocTest<ProfileCubit, ProfileState>(
    'updateProfile does nothing when form is invalid',
    build: () => ProfileCubit(authRepository, profileRepository),
    act: (cubit) => cubit.updateProfile(),
    expect: () => <ProfileState>[],
    verify: (_) => verifyNever(
      () => authRepository.updateUser(
        name: any(named: 'name'),
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    ),
  );

  blocTest<ProfileCubit, ProfileState>(
    'updateProfile emits updated when repository succeeds',
    build: () {
      when(
        () => authRepository.updateUser(
          name: any(named: 'name'),
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenReturn(TaskEither.right(null));
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) {
      cubit.editProfileForm.control('name').value = 'New Name';
      return cubit.updateProfile();
    },
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileUpdated>(),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'updateProfile emits failure when repository fails',
    build: () {
      when(
        () => authRepository.updateUser(
          name: any(named: 'name'),
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenReturn(TaskEither.left(AppException(message: 'failed')));
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) {
      cubit.editProfileForm.control('name').value = 'New Name';
      return cubit.updateProfile();
    },
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileFailure>(),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'reportBug marks form and does nothing when invalid',
    build: () => ProfileCubit(authRepository, profileRepository),
    act: (cubit) => cubit.reportBug(),
    expect: () => <ProfileState>[],
    verify: (cubit) {
      final description =
          cubit.bugReportForm.control('description') as FormControl<String>;
      expect(description.touched, isTrue);
      verifyNever(() => profileRepository.reportBug(any()));
    },
  );

  blocTest<ProfileCubit, ProfileState>(
    'reportBug emits reported and resets form on success',
    build: () {
      when(() => profileRepository.reportBug(any())).thenReturn(
        TaskEither.right(null),
      );
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) {
      cubit.bugReportForm.control('description').value = bugReport.description;
      final steps =
          cubit.bugReportForm.control('stepsToReproduce') as FormArray<String>;
      steps.add(FormControl<String>(value: bugReport.stepsToReproduce!.first));
      return cubit.reportBug();
    },
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileBugReported>(),
    ],
    verify: (cubit) {
      expect(cubit.bugReportForm.control('description').value, isNull);
      final steps =
          cubit.bugReportForm.control('stepsToReproduce') as FormArray<String>;
      expect(steps.controls, isEmpty);
    },
  );

  blocTest<ProfileCubit, ProfileState>(
    'reportBug emits failure when repository fails',
    build: () {
      when(() => profileRepository.reportBug(any())).thenReturn(
        TaskEither.left(AppException(message: 'failed')),
      );
      return ProfileCubit(authRepository, profileRepository);
    },
    act: (cubit) {
      cubit.bugReportForm.control('description').value = bugReport.description;
      return cubit.reportBug();
    },
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileFailure>(),
    ],
  );
}
