import 'package:flutter/material.dart';
import 'package:markilo/api/surikato_api.dart';
import 'package:markilo/models/http/users_response.dart';
import 'package:markilo/models/user.dart';

class UsersProvider extends ChangeNotifier {
  List<User> users = [];
  bool loading = false;
  bool ascending = true;
  int? sortColumnIndex;

  UsersProvider() {
    getUsers();
  }

  getUsers() async {
    loading = true;
    final response = await SurikatoApi.httpGet('/user');
    print(response.data);
    final usersResponse = UsersResponse.fromMap(response.data);
    users = [...usersResponse.users];
    loading = false;
    notifyListeners();
  }

  Future<User?> getUserByUuid(String uuid) async {
    try {
      final response = await SurikatoApi.httpGet("/user-by-uuid/$uuid");
      //print(response.data);
      final user = User.fromJson(response.data);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void sort<T>(Comparable<T> Function(User user) getField) {
    users.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    ascending = !ascending;
    notifyListeners();
  }

  void refreshUser(User newUser) {
    for (var i = 0; i < users.length; ++i) {
      if (users[i].uuid == newUser.uuid) {
        users[i] = newUser;
      }
    }
    notifyListeners();
  }
}
