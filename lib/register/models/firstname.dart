import 'package:formz/formz.dart';

enum FirstnameValidationError { empty }

class Firstname extends FormzInput<String, FirstnameValidationError> {
  const Firstname.pure() : super.pure('');
  const Firstname.dirty([String value = '']) : super.dirty(value);

  @override
  FirstnameValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : FirstnameValidationError.empty;
  }
}
