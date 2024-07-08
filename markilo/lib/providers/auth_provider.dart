import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:markilo/api/surikato_api.dart';
import 'package:markilo/models/http/auth_response.dart';
import 'package:markilo/models/user.dart';

import 'package:markilo/models/http/error_response.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/local_storage.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/services/notification_service.dart';
import 'package:markilo/ui/labels/custom_labels.dart';
import 'package:markilo/ui/shared/widgets/custom_elevated_button.dart';
import 'package:markilo/ui/shared/widgets/navbar_avatar.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.checking;
  User? user;
  bool _loadingLogin = false;
  int noAuthenticatedRetry = 0;

  bool get loadingLogin {
    return _loadingLogin;
  }

  set loadingLogin(bool loadingToSet) {
    _loadingLogin = loadingToSet;
    notifyListeners();
  }

  AuthProvider() {
    isAuthenticated();
  }

  login(BuildContext context, String email, String password) async {
    try {
      final data = {
        "email": email,
        "password": sha256.convert(utf8.encode(password)).toString(),
      };

      _loadingLogin = true;
      notifyListeners();
      final response = await SurikatoApi.httpPost('/user/login', data);
      if (202 == response.statusCode) {
        final authResponse = AuthResponse.fromMap(response.data);
        showForceLogoutDialog(context, authResponse);
        _loadingLogin = false;
        notifyListeners();
      } else if (200 == response.statusCode) {
        final authResponse = AuthResponse.fromMap(response.data);
        user = authResponse.user;
        DataService.user = user;
        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.accessToken);
        SurikatoApi.configureDio();
        _loadingLogin = false;
        loadData();
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationService.replaceTo(Flurorouter.homeRoute);
        });
      }
    } on Exception catch (e) {
      NotificationService.showSnackbarError('Usuario o contraseña inválida');
      _loadingLogin = false;
      notifyListeners();
    }
  }

  logout() {
    _loadingLogin = true;
    notifyListeners();
    SurikatoApi.httpPost('/user/logout', null).then((response) {
      _loadingLogin = false;
      if (200 == response.statusCode) {
        user = null;
        DataService.user = null;
        authStatus = AuthStatus.notAuthenticated;
        LocalStorage.prefs.remove('token');
        notifyListeners();
      } else {
        final errorResponse = ErrorResponse.fromMap(response.data);
        NotificationService.showSnackbarError(errorResponse.errors.description);
        _loadingLogin = false;
        notifyListeners();
      }
    }).catchError((e) {
      NotificationService.showSnackbarError('Usuario o contraseña no válidos');
      _loadingLogin = false;
      notifyListeners();
    });
  }

  register(String email, String password, String name, String surname) {
    final data = {
      "name": name,
      "surname": surname,
      "email": email,
      "password": password,
      'role_id': '2'
    };

    SurikatoApi.httpPost('/user', data).then((response) {
      if (200 == response.statusCode) {
        final authResponse = AuthResponse.fromMap(response.data);
        user = authResponse.user;
        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.accessToken);
        notifyListeners();
      } else {
        final errorResponse = ErrorResponse.fromMap(response.data);
        if (errorResponse.errors.description.contains('users_email_unique')) {
          NotificationService.showSnackbarError('E-mail already exists');
        } else {
          NotificationService.showSnackbarError(
              errorResponse.errors.description);
        }
      }
    }).catchError((e) {
      NotificationService.showSnackbarError('User or password not valid');
    });
  }

  Future<bool> isAuthenticated() async {
    authStatus = AuthStatus.checking;
    final token = LocalStorage.prefs.getString('token');
    if (null != token) {
      await SurikatoApi.httpGet('/user/is-authenticated').then((response) {
        if (200 == response.statusCode) {
          final authResponse = AuthResponse.fromMap(response.data);
          user = authResponse.user;
          DataService.user = user;
          authStatus = AuthStatus.authenticated;
          loadData();
          notifyListeners();
          return true;
        } else {
          authStatus = AuthStatus.notAuthenticated;
          notifyListeners();
          return false;
        }
      }).catchError((e) {
        authStatus = AuthStatus.notAuthenticated;
        notifyListeners();
        return false;
      });
    } else {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

    return false;
  }

  Future<bool> isAlive() async {
    await SurikatoApi.httpGet('/user/is-authenticated').then((response) {
      if (200 == response.statusCode) {
        noAuthenticatedRetry = 0;
        return true;
      } else {
        ++noAuthenticatedRetry;
        return false;
      }
    }).catchError((e) {
      ++noAuthenticatedRetry;
      return false;
    });

    return false;
  }

  AppBar setNavBar(BuildContext context, bool showNavBar) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Colors.black,
      toolbarHeight: showNavBar ? 0 : 0,
      title: Row(
        children: [
          const Spacer(),
          if (size.width > 330)
            Text(
              "Hola ${user!.name}!",
              style: CustomLabels.h4.copyWith(color: Colors.white),
            ),
          const SizedBox(
            width: 5,
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () =>
                  NavigationService.replaceTo(Flurorouter.profileRoute),
              child: const NavbarAvatar(size: 40)),
        ],
      ),
    );
  }

  loadData() async {
    DataService.appLoaded = true;
  }

  showForceLogoutDialog(BuildContext context, AuthResponse authResponse) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 230, maxWidth: 350),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_outlined))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Éste usuario ya esta conectado a Markilo',
                      style: CustomLabels.h4.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '¿Desea forzar el cierre de sesión?',
                      style: CustomLabels.h4.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomElevatedButton(
                          text: 'Cerrar sesión',
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          onPressed: () async {
                            await SurikatoApi.httpPost(
                                "/user/delete/token/${authResponse.accessToken}",
                                null);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            NotificationService.showSnackbar(
                                "Se cerro la sesión con éxito. Reintente iniciar sesión");
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomElevatedButton(
                          text: 'Cancelar',
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showUserDisconnected(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 230, maxWidth: 350),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_outlined))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Éste usuario acaba de conectarse en otro dispositivo.',
                      style: CustomLabels.h4.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Markilo cerrará su sesión',
                      style: CustomLabels.h4.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                      text: 'Aceptar',
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
