import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({this.id, this.username, this.useridentity});

  final String id;
  final String username;
  final String useridentity;

  @override
  List<Object> get props => [id, username, useridentity];

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'] as String,
      username: json['username'] as String,
      useridentity: json['userIdentity'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
        'id': instance.id,
        'username': instance.username,
        'useridentity': instance.useridentity,
      };
}
