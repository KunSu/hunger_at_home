import 'package:formz/formz.dart';

enum UserIdentityValidationError { empty }

class UserIdentity extends FormzInput<String, UserIdentityValidationError> {
  const UserIdentity.pure() : super.pure('');
  const UserIdentity.dirty([String value = '']) : super.dirty(value);

  @override
  UserIdentityValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : UserIdentityValidationError.empty;
  }
}
