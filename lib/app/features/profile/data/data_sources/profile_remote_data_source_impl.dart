import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/types/response_type.dart';
import '../../../../shared/utils/platform_utils.dart';
import '../../../../shared/utils/task_utils.dart';
import '../../../auth/auth.dart';
import '../models/bug_report_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  @override
  TaskResponse<void> reportBug(
    BugReportModel bugReport,
    CredentialsModel credentials,
  ) => task(
    () async {
      final platform = PlatformUtils();

      final ref = _firebaseFirestore.collection('bug_reports').doc();

      await ref.set({
        ...bugReport.toJson(),
        'reportedAt': FieldValue.serverTimestamp(),
        'platform': platform.operatingSystem,
        'osVersion': platform.operatingSystemVersion,
        'appVersion': platform.appVersion,
        'buildNumber': platform.buildNumber,
        'userId': credentials.userId,
      });
    },
    (error) => 'profile.errors.report_bug_failed'.tr(),
  );
}
