import '../../../../shared/types/response_type.dart';
import '../entities/bug_report.dart';

abstract interface class ProfileRepository {
  TaskResponse<void> reportBug(BugReport bugReport);
}
