import 'dart:async';
import 'package:markilo/providers/user_form_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:markilo/models/configuration/configuration/configuration.dart';
import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/providers/configuration/configurations_provider.dart';
import 'package:markilo/providers/sidemenu_provider.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/notification_service.dart';
import 'package:markilo/ui/layouts/splash/splash_layout.dart';
import 'package:markilo/ui/shared/sidebar.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final AuthProvider authProvider;

  const MainLayout(
      {super.key, required this.child, required this.authProvider});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  late ConfigurationsProvider configurationsProvider;
  bool loaded = false;
  String? newAppVersion;
  Configuration? configuration;

  @override
  void initState() {
    super.initState();
    configurationsProvider =
        Provider.of<ConfigurationsProvider>(context, listen: false);
    BackButtonInterceptor.add(backButtonInterceptor);

    Timer.periodic(
      const Duration(seconds: 20),
      (timer) async {
        if (widget.authProvider.authStatus == AuthStatus.authenticated) {
          await widget.authProvider.isAlive();
          if (widget.authProvider.noAuthenticatedRetry > 3) {
            widget.authProvider.authStatus = AuthStatus.notAuthenticated;
            if (context.mounted) {
              NotificationService.showSnackbarError(
                  'Este usuario ha iniciado sesión en otro dispositivo');
            }
          }
        }
      },
    );
  }

  Future<bool> getDataProviders(BuildContext context) async {
    if (!loaded) {
      loaded = true;
      await configurationsProvider.getConfiguration();
    }
    return true;
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await checkForUpdateOnLoad();
  }

  Future<void> checkForUpdateOnLoad() async {
    configuration = await configurationsProvider.getConfiguration();
    if (configuration != null) {
      await checkForUpdate(configuration!);
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backButtonInterceptor);
    super.dispose();
  }

  Future<bool> backButtonInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    return true;
  }

  Future<void> checkForUpdate(Configuration configuration) async {
    try {
      if (DataService.user!.appVersion != configuration.appVersion) {
        setState(() {
          newAppVersion = configuration.appVersion;
        });
      }
    } catch (e) {
      debugPrint("Error fetching version: $e");
    }
  }

  Future<void> updateVersion() async {
    UserFormProvider userFormProvider = Provider.of(context, listen: false);
    DataService.user!.appVersion = configuration!.appVersion;
    await userFormProvider.updateUser(DataService.user!);
    html.window.location.reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getDataProviders(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SplashLayout();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Scaffold(
                key: SideMenuProvider.scaffoldKey,
                backgroundColor: Colors.blue[700],
                drawer: const Drawer(width: 200, child: Sidebar()),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        if (newAppVersion != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.orange[700],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '¡Nueva versión disponible ($newAppVersion)!',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                TextButton(
                                  onPressed: updateVersion,
                                  child: const Text(
                                    'Actualizar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: widget.child,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }
        });
  }
}
