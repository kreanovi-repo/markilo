import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool validateForm() {
    if (formKeyLogin.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
