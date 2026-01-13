import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../shared/errors/app_exception.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  final signInForm = FormGroup({
    'email': FormControl<String>(),
    'password': FormControl<String>(),
  });

  final signUpForm = FormGroup(
    {
      'name': FormControl<String>(validators: [Validators.required]),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'confirmPassword': FormControl<String>(),
    },
    validators: [
      const MustMatchValidator('password', 'confirmPassword', false),
    ],
  );

  Future<void> signUpWithEmail() async {
    signUpForm.markAllAsTouched();

    if (signUpForm.invalid) {
      return;
    }

    final name = signUpForm.control('name').value as String?;
    final email = signUpForm.control('email').value as String?;
    final password = signUpForm.control('password').value as String?;

    emit(const AuthLoading());

    final response = await _authRepository
        .signUp(name: name!, email: email!, password: password!)
        .run();

    response.fold(
      (exception) => emit(AuthFailure(exception)),
      (_) => emit(const AuthSigned(AuthOperation.signUp)),
    );
  }

  Future<void> signInWithProvider(AuthProvider provider) async {
    final email = signInForm.control('email').value as String?;
    final password = signInForm.control('password').value as String?;

    if (!_isSignInValid(provider, email, password)) {
      return;
    }

    emit(const AuthLoading());

    final response = await switch (provider) {
      AuthProvider.google => _authRepository.signWithGoogle().run(),
      AuthProvider.apple => _authRepository.signWithApple().run(),
      AuthProvider.email =>
        _authRepository.signIn(email: email!, password: password!).run(),
    };

    response.fold(
      (exception) => emit(AuthFailure(exception)),
      (_) => emit(const AuthSigned(AuthOperation.signIn)),
    );
  }

  bool _isSignInValid(AuthProvider provider, String? email, String? password) {
    if (provider != AuthProvider.email) {
      return true;
    }

    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  @override
  Future<void> close() {
    signInForm.dispose();
    signUpForm.dispose();
    return super.close();
  }
}
