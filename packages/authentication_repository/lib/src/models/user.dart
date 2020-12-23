import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({this.id, this.email, this.companyID, this.useridentity});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'] as String,
      email: json['email'] as String,
      companyID: json['companyID'] as String,
      useridentity: json['userIdentity'] as String,
    );
  }

  final String id;
  final String email;
  final String companyID;
  final String useridentity;

  @override
  List<Object> get props => [id, email, companyID, useridentity];

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
        'id': instance.id,
        'email': instance.email,
        'companyID': instance.companyID,
        'useridentity': instance.useridentity,
      };
}
