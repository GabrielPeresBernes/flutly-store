import 'package:reactive_forms/reactive_forms.dart';

class AuthUtils {
  static FormGroup buildSignInForm() => FormGroup({
    'email': FormControl<String>(),
    'password': FormControl<String>(),
  });

  static FormGroup buildSignUpForm() => FormGroup(
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
}
