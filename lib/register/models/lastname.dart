import 'package:formz/formz.dart';

enum LastnameValidationError { empty }

class Lastname extends FormzInput<String, LastnameValidationError> {
  const Lastname.pure() : super.pure('');
  const Lastname.dirty([String value = '']) : super.dirty(value);

  @override
  LastnameValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : LastnameValidationError.empty;
  }
}
