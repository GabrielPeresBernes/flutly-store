import 'package:reactive_forms/reactive_forms.dart';

/// Validator to ensure that when changing password, both current
/// and new passwords are provided.
class PasswordChangeValidator extends Validator<dynamic> {
  const PasswordChangeValidator(
    this.currentPasswordControlName,
    this.newPasswordControlName,
  ) : super();

  final String currentPasswordControlName;
  final String newPasswordControlName;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = {'passwordChange': true};

    if (control is! FormGroup) {
      return error;
    }

    final currentPasswordControl = control.control(currentPasswordControlName);
    final newPasswordControl = control.control(newPasswordControlName);

    if (newPasswordControl.value != null &&
        currentPasswordControl.value == null) {
      currentPasswordControl
        ..setErrors(error)
        ..markAsTouched();
    } else if (newPasswordControl.value.toString().isNotEmpty &&
        currentPasswordControl.value.toString().isEmpty) {
      currentPasswordControl
        ..setErrors(error)
        ..markAsTouched();
    } else {
      newPasswordControl.removeError(ValidationMessage.mustMatch);
    }

    return null;
  }
}
