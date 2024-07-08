import 'dart:convert';

class ErrorResponse {
  ErrorResponse({
    required this.errors,
  });

  Errors errors;

  factory ErrorResponse.fromJson(String str) =>
      ErrorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ErrorResponse.fromMap(Map<String, dynamic> json) => ErrorResponse(
        errors: Errors.fromMap(json["errors"]),
      );

  Map<String, dynamic> toMap() => {
        "errors": errors.toMap(),
      };
}

class Errors {
  Errors({
    required this.status,
    required this.title,
    required this.description,
  });

  String status;
  String title;
  String description;

  factory Errors.fromJson(String str) => Errors.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Errors.fromMap(Map<String, dynamic> json) => Errors(
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
