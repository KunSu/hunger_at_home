import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.companyID,
    this.email,
    this.firstName,
    this.lastName,
    this.status,
    this.phoneNumber,
    this.userIdentity,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      companyID: json['companyID'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      status: json['status'],
      phoneNumber: json['phoneNumber'],
      userIdentity: json['userIdentity'],
    );
  }

  final String id;
  final String companyID;
  final String email;
  final String firstName;
  final String lastName;
  final String status;
  final String phoneNumber;
  final String userIdentity;

  @override
  List<Object> get props => [
        id,
        companyID,
        email,
        firstName,
        lastName,
        status,
        phoneNumber,
        userIdentity,
      ];
}
