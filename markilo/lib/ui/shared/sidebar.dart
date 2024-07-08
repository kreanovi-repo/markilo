import 'package:line_icons/line_icons.dart';
import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/providers/sidemenu_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/types/Constants.dart';
import 'package:markilo/ui/shared/widgets/logo.dart';
import 'package:markilo/ui/shared/widgets/menu_item.dart';
import 'package:markilo/ui/shared/widgets/text_separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void navigateTo(String routeName) {
    NavigationService.replaceTo(routeName);
    //SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      width: Constants.sidebarWidth,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    toggleDrawer();
                  },
                  icon: const Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                  )),
            ],
          ),
          const Logo(),
          const SizedBox(
            height: 50,
          ),
          const TextSeparator(text: 'Principal'),
          SidebarMenuItem(
              text: 'Inicio',
              icon: Icons.home_outlined,
              isActive: (sideMenuProvider.currentPage == Flurorouter.homeRoute),
              onPressed: () {
                navigateTo(Flurorouter.homeRoute);
                toggleDrawer();
              }),
          SidebarMenuItem(
              text: 'Tablero Voley',
              icon: LineIcons.volleyballBall,
              isActive: (sideMenuProvider.currentPage ==
                  Flurorouter.volleyDashboardRoute),
              onPressed: () {
                navigateTo(Flurorouter.volleyDashboardRoute);
                toggleDrawer();
              }),
          const SizedBox(
            height: 20,
          ),
          const TextSeparator(text: 'Usuario'),
          SidebarMenuItem(
              text: 'Mi perfil',
              icon: Icons.person_outlined,
              isActive:
                  (sideMenuProvider.currentPage == Flurorouter.profileRoute),
              onPressed: () {
                navigateTo(Flurorouter.profileRoute);
                toggleDrawer();
              }),
          SidebarMenuItem(
              text: 'Cerrar sesión',
              icon: Icons.logout_outlined,
              isActive: false,
              onPressed: () async {
                //Provider.of<HomeProvider>(context, listen: false).clearData();
                authProvider.logout();
                Future.delayed(const Duration(milliseconds: 400), () {
                  toggleDrawer();
                });
              }),
          Center(
            heightFactor: 1,
            widthFactor: 1,
            child: authProvider.loadingLogin
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }

  toggleDrawer() async {
    if (SideMenuProvider.scaffoldKey.currentState!.isDrawerOpen) {
      SideMenuProvider.scaffoldKey.currentState!.closeDrawer();
    } else {
      SideMenuProvider.scaffoldKey.currentState!.openEndDrawer();
    }
  }

  BoxDecoration buildBoxDecoration() => const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromARGB(255, 0, 42, 54),
        Color.fromARGB(255, 0, 29, 37)
      ]),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]);
}
