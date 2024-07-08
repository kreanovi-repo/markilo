import 'dart:typed_data';

import 'package:markilo/api/surikato_api.dart';
import 'package:flutter/material.dart';
import 'package:markilo/models/user.dart';

class UserFormProvider extends ChangeNotifier {
  User? user;
  late GlobalKey<FormState> formKey;
  bool updating = false;

  bool _validateForm() {
    return formKey.currentState!.validate();
  }

  updateListener() {
    notifyListeners();
  }

  Future updateUser(User user) async {
    updating = true;
    notifyListeners();
    final data = {
      'name': user.name,
      'surname': user.surname,
      'dni': user.dni,
      'cell_phone': user.cellPhone,
      'email': user.email,
      'image': user.image,
      'background_color_voley': user.backgroundColorVoley,
    };

    try {
      final response =
          await SurikatoApi.httpPost("/user/update/${user!.id}", data);
      if (200 == response.statusCode) {
        updating = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('error en updateUser: $e');
      updating = false;
      notifyListeners();
      return false;
    }
  }

  Future<User> uploadImage(String path, Uint8List bytes) async {
    try {
      await SurikatoApi.uploadFile(path, bytes).then((response) {
        if (200 == response.statusCode) {
          user = User.fromJson(response.data);
          notifyListeners();
        }
      });

      return user!;
    } catch (e) {
      print(e.toString());
      throw ('Error al actualizar la imagen');
    }
  }
}
