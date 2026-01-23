import 'package:flutly_store/app/shared/validators/password_change_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  test('returns error when control is not a FormGroup', () {
    const validator = PasswordChangeValidator('current', 'new');

    final result = validator.validate(FormControl<String>());

    expect(result, {'passwordChange': true});
  });

  test('sets error when new password is set but current is null', () {
    const validator = PasswordChangeValidator('current', 'new');
    final form = FormGroup({
      'current': FormControl<String>(),
      'new': FormControl<String>(value: 'new-pass'),
    });

    final result = validator.validate(form);
    final current = form.control('current');

    expect(result, isNull);
    expect(current.hasError('passwordChange'), isTrue);
    expect(current.touched, isTrue);
  });

  test('sets error when new password is non-empty and current is empty', () {
    const validator = PasswordChangeValidator('current', 'new');
    final form = FormGroup({
      'current': FormControl<String>(value: ''),
      'new': FormControl<String>(value: 'new-pass'),
    });

    final result = validator.validate(form);
    final current = form.control('current');

    expect(result, isNull);
    expect(current.hasError('passwordChange'), isTrue);
    expect(current.touched, isTrue);
  });

  test('clears mustMatch error on new password when valid', () {
    const validator = PasswordChangeValidator('current', 'new');
    final form = FormGroup({
      'current': FormControl<String>(value: 'old-pass'),
      'new': FormControl<String>(value: 'new-pass')
        ..setErrors({ValidationMessage.mustMatch: true}),
    });

    final result = validator.validate(form);
    final current = form.control('current');
    final updatedNew = form.control('new');

    expect(result, isNull);
    expect(current.hasError('passwordChange'), isFalse);
    expect(updatedNew.hasError(ValidationMessage.mustMatch), isFalse);
  });
}
