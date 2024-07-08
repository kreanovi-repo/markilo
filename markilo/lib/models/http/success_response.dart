// To parse this JSON data, do
//
//     final successResponse = successResponseFromMap(jsonString);

import 'dart:convert';

class SuccessResponse {
  SuccessResponse({
    required this.success,
  });

  Success success;

  factory SuccessResponse.fromJson(String str) =>
      SuccessResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SuccessResponse.fromMap(Map<String, dynamic> json) => SuccessResponse(
        success: Success.fromMap(json["success"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success.toMap(),
      };
}

class Success {
  Success({
    required this.status,
    required this.title,
    required this.description,
  });

  int status;
  String title;
  String description;

  factory Success.fromJson(String str) => Success.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Success.fromMap(Map<String, dynamic> json) => Success(
        status: json["status"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "title": title,
        "description": description,
      };
}
