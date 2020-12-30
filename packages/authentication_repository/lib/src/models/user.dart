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

  // Map<String, dynamic> toJson() => _$UserToJson(this);

  // Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  //       'id': instance.id,
  //       'email': instance.email,
  //       'companyID': instance.companyID,
  //       'useridentity': instance.useridentity,
  //     };
}
