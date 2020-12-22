part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterFirstnameChanged extends RegisterEvent {
  const RegisterFirstnameChanged(this.firstname);

  final String firstname;

  @override
  List<Object> get props => [firstname];
}

class RegisterLastnameChanged extends RegisterEvent {
  const RegisterLastnameChanged(this.lastname);

  final String lastname;

  @override
  List<Object> get props => [lastname];
}

class RegisterPhoneNumberChanged extends RegisterEvent {
  const RegisterPhoneNumberChanged(this.phonenumber);

  final String phonenumber;

  @override
  List<Object> get props => [phonenumber];
}

class RegisterUserIdentityChanged extends RegisterEvent {
  const RegisterUserIdentityChanged(this.useridentity);

  final String useridentity;

  @override
  List<Object> get props => [useridentity];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
