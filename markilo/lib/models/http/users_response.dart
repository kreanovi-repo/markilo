import 'dart:convert';
import 'package:markilo/models/user.dart';

class UsersResponse {
  UsersResponse({
    required this.users,
  });

  List<User> users;

  factory UsersResponse.fromJson(String str) =>
      UsersResponse.fromMap(json.decode(str));

  factory UsersResponse.fromMap(Map<String, dynamic> json) => UsersResponse(
        users: List<User>.from(json["Users"].map((x) => User.fromJson(x))),
      );
}
