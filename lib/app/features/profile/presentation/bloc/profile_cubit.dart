import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../../../shared/validators/password_change_validator.dart';
import '../../../auth/auth.dart';
import '../../domain/entities/bug_report.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository, this._profileRepository)
    : super(const ProfileInitial());

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  final editProfileForm = FormGroup(
    {
      'name': FormControl<String>(
        validators: [Validators.required, Validators.required],
      ),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
        disabled: true,
      ),
      'currentPassword': FormControl<String>(
        validators: [Validators.minLength(6)],
      ),
      'newPassword': FormControl<String>(
        validators: [Validators.minLength(6)],
      ),
      'confirmNewPassword': FormControl<String>(),
    },
    validators: [
      const MustMatchValidator('newPassword', 'confirmNewPassword', false),
      const PasswordChangeValidator('currentPassword', 'newPassword'),
    ],
  );

  final bugReportForm = FormGroup(
    {
      'description': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(1000)],
      ),
      'stepsToReproduce': FormArray<String>([]),
      'expectedBehavior': FormControl<String>(
        validators: [Validators.maxLength(1000)],
      ),
      'issueType': FormControl<String>(),
      'screen': FormControl<String>(),
      'frequency': FormControl<String>(),
    },
  );

  Future<void> getUserData() async {
    final response = await _authRepository.getCredentials().run();

    response.fold(
      (exception) => emit(ProfileFailure(exception: exception)),
      (credentialsOption) {
        credentialsOption.match(
          () => emit(
            ProfileFailure(
              exception: AppException(message: 'profile.errors.load_user'.tr()),
            ),
          ),
          (credentials) {
            editProfileForm.control('name').value = credentials.name;
            editProfileForm.control('email').value = credentials.email;

            if (credentials.provider != AuthProvider.email) {
              editProfileForm.control('currentPassword').markAsDisabled();
              editProfileForm.control('newPassword').markAsDisabled();
              editProfileForm.control('confirmNewPassword').markAsDisabled();
            }
          },
        );
      },
    );
  }

  Future<void> updateProfile() async {
    if (!editProfileForm.valid) {
      return;
    }

    final name = editProfileForm.control('name').value as String?;
    final currentPassword =
        editProfileForm.control('currentPassword').value as String?;
    final newPassword = editProfileForm.control('newPassword').value as String?;

    emit(const ProfileLoading());

    final response = await _authRepository
        .updateUser(
          name: name,
          currentPassword: currentPassword,
          newPassword: newPassword,
        )
        .run();

    response.fold(
      (exception) => emit(ProfileFailure(exception: exception)),
      (_) => emit(const ProfileUpdated()),
    );
  }

  Future<void> reportBug() async {
    if (!bugReportForm.valid) {
      bugReportForm.markAllAsTouched();
      return;
    }

    final description = bugReportForm.control('description').value as String;
    final stepsToReproduce =
        (bugReportForm.control('stepsToReproduce') as FormArray<String>).value
            ?.whereType<String>()
            .toList();
    final expectedBehavior =
        bugReportForm.control('expectedBehavior').value as String?;
    final issueType = bugReportForm.control('issueType').value as String?;
    final screen = bugReportForm.control('screen').value as String?;
    final frequency = bugReportForm.control('frequency').value as String?;

    emit(const ProfileLoading());

    final response = await _profileRepository
        .reportBug(
          BugReport(
            description: description,
            stepsToReproduce: stepsToReproduce,
            expectedBehavior: expectedBehavior,
            issueType: issueType,
            screen: screen,
            frequency: frequency,
          ),
        )
        .run();

    response.fold(
      (exception) => emit(ProfileFailure(exception: exception)),
      (_) {
        bugReportForm.reset();
        (bugReportForm.control('stepsToReproduce') as FormArray<String>)
            .clear();
        emit(const ProfileBugReported());
      },
    );
  }

  @override
  Future<void> close() {
    editProfileForm.dispose();
    bugReportForm.dispose();
    return super.close();
  }
}
