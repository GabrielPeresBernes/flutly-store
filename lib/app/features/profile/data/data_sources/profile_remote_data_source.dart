import '../../../../shared/types/response_type.dart';
import '../../../auth/auth.dart';
import '../models/bug_report_model.dart';

abstract interface class ProfileRemoteDataSource {
  TaskResponse<void> reportBug(
    BugReportModel bugReport,
    CredentialsModel credentials,
  );
}
