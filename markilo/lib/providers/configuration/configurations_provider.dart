import 'package:flutter/material.dart';
import 'package:markilo/api/markilo_api.dart';
import 'package:markilo/models/configuration/configuration.dart';

class ConfigurationsProvider extends ChangeNotifier {
  Future<Configuration?> getConfiguration() async {
    try {
      final response = await MarkiloApi.httpGet("/configuration/1");
      //print(response.data);
      return Configuration.fromJson(response.data);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
