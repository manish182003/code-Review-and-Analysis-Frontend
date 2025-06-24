import 'dart:convert';

class UserModel {
  final String? userId;
  final String? email;

  UserModel({this.userId, this.email});

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'email': email};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['data']['id'] ?? '',
      email: map['data']['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
