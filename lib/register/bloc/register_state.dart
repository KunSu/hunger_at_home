part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.firstname = const Firstname.pure(),
    this.lastname = const Lastname.pure(),
    this.phonenumber = const PhoneNumber.pure(),
    this.useridentity = const UserIdentity.pure(),
  });

  final FormzStatus status;
  final Email email;
  final Password password;
  final Firstname firstname;
  final Lastname lastname;
  final PhoneNumber phonenumber;
  final UserIdentity useridentity;

  RegisterState copyWith({
    FormzStatus status,
    Email email,
    Password password,
    Firstname firstname,
    Lastname lastname,
    PhoneNumber phonenumber,
    UserIdentity useridentity,
  }) {
    return RegisterState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phonenumber: phonenumber ?? this.phonenumber,
      useridentity: useridentity ?? this.useridentity,
    );
  }

  @override
  List<Object> get props =>
      [status, email, password, firstname, lastname, phonenumber, useridentity];
}
