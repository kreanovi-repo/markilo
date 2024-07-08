import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:markilo/models/user.dart';

class DataService {
  static bool appLoaded = false;

  static Map<String, String>? configuration;

  static User? user;
  static int order = 0;

  static bool showNavBar = true;

  //////////////////////////////////////////
  ///           PUBLIC METHODS           ///
  //////////////////////////////////////////
  static getConfiguration() async {
    final String data =
        await rootBundle.loadString('assets/configuration/configuration.json');
    configuration = Map.from(json.decode(data));
  }
}
