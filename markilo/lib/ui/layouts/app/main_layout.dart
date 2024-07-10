import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/providers/home_provider.dart';
import 'package:markilo/providers/sidemenu_provider.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/notification_service.dart';
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
  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    BackButtonInterceptor.remove(backButtonInterceptor);
    super.dispose();
  }

  Future<bool> backButtonInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    return Overlay(
      initialEntries: [
        OverlayEntry(
            builder: (context) => Scaffold(
                key: SideMenuProvider.scaffoldKey,
                backgroundColor: homeProvider
                    .stringToColor(DataService.user!.backgroundColorVoley),
                drawer: const Drawer(width: 200, child: Sidebar()),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            child: widget.child)
                      ],
                    ),
                  ],
                ))),
      ],
    );
  }
}
