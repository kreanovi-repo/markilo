import 'dart:convert';

class Configuration {
  int id;
  String appVersion;
  DateTime buildDate;
  String hash;

  Configuration({
    required this.id,
    required this.appVersion,
    required this.buildDate,
    required this.hash,
  });

  factory Configuration.fromRawJson(String str) =>
      Configuration.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
        id: json["id"],
        appVersion: json["app_version"],
        buildDate: DateTime.parse(json["build_date"]),
        hash: json["hash"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_version": appVersion,
        "build_date": buildDate.toIso8601String(),
        "hash": hash,
      };
}
