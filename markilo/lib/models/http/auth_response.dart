import 'dart:convert';

import 'package:markilo/models/user.dart';

class AuthResponse {
  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  User user;
  String accessToken;
  String tokenType;

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        user: User.fromJson(json["user"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );
}
