import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../../../shared/types/response_type.dart';
import '../../../auth/auth.dart';
import '../../domain/entities/bug_report.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/bug_report_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    this._remoteDataSource,
    this._authLocalDataSource,
  );

  final ProfileRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  @override
  TaskResponse<void> reportBug(BugReport bugReport) {
    return _authLocalDataSource.getCredentials().flatMap(
      (credentialsOption) => credentialsOption.match(
        () => TaskResponse.left(
          AppException(message: 'profile.errors.not_authenticated'.tr()),
        ),
        (credentials) => _remoteDataSource.reportBug(
          BugReportModel.fromEntity(bugReport),
          credentials,
        ),
      ),
    );
  }
}
