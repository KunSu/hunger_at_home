import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({this.id, this.email, this.useridentity});

  final String id;
  final String email;
  final String useridentity;

  @override
  List<Object> get props => [id, email, useridentity];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'] as String,
      email: json['email'] as String,
      useridentity: json['userIdentity'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
        'id': instance.id,
        'email': instance.email,
        'useridentity': instance.useridentity,
      };
}
