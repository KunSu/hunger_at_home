part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.firstname = const Firstname.pure(),
    this.lastname = const Lastname.pure(),
    this.phonenumber = const PhoneNumber.pure(),
    this.useridentity = const UserIdentity.pure(),
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final Firstname firstname;
  final Lastname lastname;
  final PhoneNumber phonenumber;
  final UserIdentity useridentity;

  RegisterState copyWith({
    FormzStatus status,
    Username username,
    Password password,
    Firstname firstname,
    Lastname lastname,
    PhoneNumber phonenumber,
    UserIdentity useridentity,
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phonenumber: phonenumber ?? this.phonenumber,
      useridentity: useridentity ?? this.useridentity,
    );
  }

  @override
  List<Object> get props => [
        status,
        username,
        password,
        firstname,
        lastname,
        phonenumber,
        useridentity
      ];
}
