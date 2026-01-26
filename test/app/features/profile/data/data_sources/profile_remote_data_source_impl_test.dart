import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutly_store/app/features/auth/data/models/credentials_model.dart';
import 'package:flutly_store/app/features/profile/data/data_sources/profile_remote_data_source_impl.dart';
import 'package:flutly_store/app/features/profile/data/models/bug_report_model.dart';
import 'package:flutly_store/app/shared/utils/platform_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';

import '../../../../../utils/test_utils.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockLocalPlatform extends Mock implements LocalPlatform {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> collection;
  late DocumentReference<Map<String, dynamic>> doc;
  late PackageInfo packageInfo;
  late LocalPlatform localPlatform;
  late ProfileRemoteDataSourceImpl dataSource;

  const bugReport = BugReportModel(
    description: 'Crash on checkout',
    stepsToReproduce: ['Open cart', 'Tap checkout'],
    expectedBehavior: 'Checkout should open',
    issueType: 'Crash',
    screen: 'Cart',
    frequency: 'Always',
  );

  const credentials = CredentialsModel(
    userId: 'user-1',
    name: 'User',
    email: 'user@test.com',
    provider: 'email',
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    firestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    doc = MockDocumentReference();
    packageInfo = MockPackageInfo();
    localPlatform = MockLocalPlatform();
    dataSource = ProfileRemoteDataSourceImpl(
      firestore,
      platformUtils: PlatformUtils(
        packageInfo: packageInfo,
        localPlatform: localPlatform,
      ),
    );

    when(() => packageInfo.version).thenReturn('1.2.3');
    when(() => packageInfo.buildNumber).thenReturn('42');

    when(() => localPlatform.operatingSystem).thenReturn('android');
    when(() => localPlatform.operatingSystemVersion).thenReturn('Android 11');

    when(() => firestore.collection('bug_reports')).thenReturn(collection);
    when(() => collection.doc()).thenReturn(doc);
  });

  test('reportBug sends bug report with metadata', () async {
    when(() => doc.set(any())).thenAnswer((_) async {});

    final result = await dataSource.reportBug(bugReport, credentials).run();

    expect(result.isRight(), isTrue);

    final captured =
        verify(() => doc.set(captureAny())).captured.single
            as Map<String, dynamic>;
    expect(captured['description'], bugReport.description);
    expect(captured['stepsToReproduce'], bugReport.stepsToReproduce);
    expect(captured['expectedBehavior'], bugReport.expectedBehavior);
    expect(captured['issueType'], bugReport.issueType);
    expect(captured['screen'], bugReport.screen);
    expect(captured['frequency'], bugReport.frequency);
    expect(captured['userId'], credentials.userId);
    expect(captured['platform'], 'android');
    expect(captured['osVersion'], 'Android 11');
    expect(captured['appVersion'], '1.2.3');
    expect(captured['buildNumber'], '42');
  });
}
