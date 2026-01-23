import 'package:flutly_store/app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:flutly_store/app/features/auth/data/models/credentials_model.dart';
import 'package:flutly_store/app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:flutly_store/app/features/profile/data/models/bug_report_model.dart';
import 'package:flutly_store/app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutly_store/app/features/profile/domain/entities/bug_report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class FakeCredentialsModel extends Fake implements CredentialsModel {}

class FakeBugReportModel extends Fake implements BugReportModel {}

void main() {
  late ProfileRemoteDataSource remoteDataSource;
  late AuthLocalDataSource authLocalDataSource;
  late ProfileRepositoryImpl repository;

  final bugReport = BugReport(
    description: 'Crash on checkout',
    stepsToReproduce: const ['Open cart', 'Tap checkout'],
    expectedBehavior: 'Checkout should open',
    issueType: 'Crash',
    screen: 'Cart',
    frequency: 'Always',
  );

  final credentials = CredentialsModel(
    userId: 'user-1',
    name: 'User',
    email: 'user@test.com',
    provider: 'email',
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(FakeBugReportModel());
    registerFallbackValue(FakeCredentialsModel());
  });

  setUp(() {
    remoteDataSource = MockProfileRemoteDataSource();
    authLocalDataSource = MockAuthLocalDataSource();
    repository = ProfileRepositoryImpl(remoteDataSource, authLocalDataSource);
  });

  test('reportBug returns error when user is not authenticated', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(none()),
    );

    final result = await repository.reportBug(bugReport).run();

    expect(result.isLeft(), isTrue);
    result.match(
      (error) => expect(error.message, 'profile.errors.not_authenticated'),
      (_) => fail('Expected error'),
    );
    verifyNever(() => remoteDataSource.reportBug(any(), any()));
  });

  test('reportBug forwards bug report when user is authenticated', () async {
    when(() => authLocalDataSource.getCredentials()).thenReturn(
      TaskEither.right(Option.of(credentials)),
    );
    when(() => remoteDataSource.reportBug(any(), credentials)).thenReturn(
      TaskEither.right(null),
    );

    final result = await repository.reportBug(bugReport).run();

    expect(result.isRight(), isTrue);
    final captured =
        verify(
              () => remoteDataSource.reportBug(captureAny(), credentials),
            ).captured.single
            as BugReportModel;
    expect(captured.description, bugReport.description);
    expect(captured.stepsToReproduce, bugReport.stepsToReproduce);
    expect(captured.expectedBehavior, bugReport.expectedBehavior);
    expect(captured.issueType, bugReport.issueType);
    expect(captured.screen, bugReport.screen);
    expect(captured.frequency, bugReport.frequency);
  });
}
