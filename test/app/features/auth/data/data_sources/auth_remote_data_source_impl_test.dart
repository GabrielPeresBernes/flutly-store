import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutly_store/app/features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:flutly_store/app/features/auth/domain/entities/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sign_in_with_apple_platform_interface/sign_in_with_apple_platform_interface.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class FakeAuthCredential extends Fake implements AuthCredential {}

class MockSignInWithApplePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements SignInWithApplePlatform {}

void main() {
  late FirebaseAuth firebaseAuth;
  late GoogleSignIn googleSignIn;
  late AuthRemoteDataSourceImpl dataSource;
  late User user;
  late UserCredential userCredential;
  late SignInWithApplePlatform signInWithApplePlatform;
  late SignInWithApplePlatform originalSignInWithApplePlatform;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());

    originalSignInWithApplePlatform = SignInWithApplePlatform.instance;
  });

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    dataSource = AuthRemoteDataSourceImpl(firebaseAuth, googleSignIn);
    user = MockUser();
    userCredential = MockUserCredential();
    signInWithApplePlatform = MockSignInWithApplePlatform();

    SignInWithApplePlatform.instance = signInWithApplePlatform;
  });

  tearDownAll(() {
    SignInWithApplePlatform.instance = originalSignInWithApplePlatform;
  });

  test('signIn returns credentials using current user', () async {
    when(
      () => firebaseAuth.signInWithEmailAndPassword(
        email: 'user@test.com',
        password: '123',
      ),
    ).thenAnswer((_) async => userCredential);
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('1');
    when(() => user.displayName).thenReturn('User');
    when(() => user.email).thenReturn('user@test.com');

    final result = await dataSource
        .signIn(email: 'user@test.com', password: '123')
        .run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.userId, '1');
        expect(value.name, 'User');
        expect(value.email, 'user@test.com');
        expect(value.provider, AuthProvider.email.name);
      },
    );
  });

  test('signUp returns credentials after updating display name', () async {
    when(
      () => firebaseAuth.createUserWithEmailAndPassword(
        email: 'user@test.com',
        password: '123',
      ),
    ).thenAnswer((_) async => userCredential);
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('1');
    when(() => user.email).thenReturn('user@test.com');
    when(() => user.updateDisplayName('New User')).thenAnswer((_) async {});

    final result = await dataSource
        .signUp(name: 'New User', email: 'user@test.com', password: '123')
        .run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.userId, '1');
        expect(value.name, 'New User');
        expect(value.email, 'user@test.com');
        expect(value.provider, AuthProvider.email.name);
      },
    );
  });

  test('signOut delegates to firebase auth', () async {
    when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

    final result = await dataSource.signOut().run();

    expect(result.isRight(), isTrue);
    verify(() => firebaseAuth.signOut()).called(1);
  });

  test(
    'updateUser reauthenticates and updates password when requested',
    () async {
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => user.email).thenReturn('user@test.com');
      when(() => user.uid).thenReturn('1');
      when(() => user.displayName).thenReturn('Updated');
      when(
        () => user.reauthenticateWithCredential(any()),
      ).thenAnswer((_) async => userCredential);
      when(() => user.updatePassword('newpass')).thenAnswer((_) async {});
      when(() => user.updateDisplayName('Updated')).thenAnswer((_) async {});

      final result = await dataSource
          .updateUser(
            provider: AuthProvider.email,
            name: 'Updated',
            currentPassword: 'oldpass',
            newPassword: 'newpass',
          )
          .run();

      expect(result.isRight(), isTrue);
      result.match(
        (_) => fail('Expected credentials'),
        (value) {
          expect(value.userId, '1');
          expect(value.name, 'Updated');
          expect(value.email, 'user@test.com');
          expect(value.provider, AuthProvider.email.name);
        },
      );

      verify(() => user.reauthenticateWithCredential(any())).called(1);
      verify(() => user.updatePassword('newpass')).called(1);
      verify(() => user.updateDisplayName('Updated')).called(1);
    },
  );

  test('signWithGoogle returns credentials using current user', () async {
    final googleUser = MockGoogleSignInAccount();
    final googleAuth = MockGoogleSignInAuthentication();

    when(() => googleSignIn.authenticate()).thenAnswer((_) async => googleUser);
    when(() => googleUser.authentication).thenReturn(googleAuth);
    when(() => googleAuth.idToken).thenReturn('token');
    when(() => googleUser.displayName).thenReturn('Google User');
    when(
      () => firebaseAuth.signInWithCredential(any()),
    ).thenAnswer((_) async => userCredential);
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('1');
    when(() => user.displayName).thenReturn('Google User');
    when(() => user.email).thenReturn('user@test.com');
    when(() => user.updateDisplayName('Google User')).thenAnswer((_) async {});

    final result = await dataSource.signWithGoogle().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.userId, '1');
        expect(value.name, 'Google User');
        expect(value.email, 'user@test.com');
        expect(value.provider, AuthProvider.google.name);
      },
    );

    verify(() => user.updateDisplayName('Google User')).called(1);
  });

  test('signWithApple returns credentials using current user', () async {
    const appleCredential = AuthorizationCredentialAppleID(
      userIdentifier: 'user',
      givenName: 'Apple',
      familyName: 'User',
      authorizationCode: 'code',
      email: 'user@test.com',
      identityToken: 'token',
      state: 'state',
    );

    when(
      () => signInWithApplePlatform.getAppleIDCredential(
        scopes: any(named: 'scopes'),
        webAuthenticationOptions: any(named: 'webAuthenticationOptions'),
        nonce: any(named: 'nonce'),
        state: any(named: 'state'),
      ),
    ).thenAnswer((_) async => appleCredential);
    when(
      () => firebaseAuth.signInWithCredential(any()),
    ).thenAnswer((_) async => userCredential);
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('1');
    when(() => user.displayName).thenReturn('Apple');
    when(() => user.email).thenReturn('user@test.com');
    when(() => user.updateDisplayName('Apple')).thenAnswer((_) async {});

    final result = await dataSource.signWithApple().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected credentials'),
      (value) {
        expect(value.userId, '1');
        expect(value.name, 'Apple');
        expect(value.email, 'user@test.com');
        expect(value.provider, AuthProvider.apple.name);
      },
    );

    verify(() => user.updateDisplayName('Apple')).called(1);
  });
}
