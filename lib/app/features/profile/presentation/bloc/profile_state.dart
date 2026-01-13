part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileUpdated extends ProfileState {
  const ProfileUpdated();
}

final class ProfileBugReported extends ProfileState {
  const ProfileBugReported();
}

final class ProfileFailure extends ProfileState {
  const ProfileFailure({required this.exception});

  final AppException exception;
}
