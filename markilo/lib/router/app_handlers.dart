import 'package:markilo/services/data_service.dart';
import 'package:markilo/ui/views/dashboard_voley/dashboard_voley_view.dart';
import 'package:markilo/ui/views/user_view.dart';
import 'package:markilo/ui/views/users_view.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/providers/sidemenu_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/ui/views/profile_view.dart';
import 'package:markilo/ui/views/home_view.dart';
import 'package:markilo/ui/views/login_view.dart';

class AppHandlers {
  static Handler home = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.homeRoute);
    if (AuthStatus.authenticated == authProvider.authStatus) {
      return const HomeView();
    } else {
      return const LoginView();
    }
  });

  static Handler profile = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.profileRoute);
    if (AuthStatus.authenticated == authProvider.authStatus) {
      return ProfileView(user: authProvider.user!);
    } else {
      return const LoginView();
    }
  });

  static Handler users = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.usersRoute);
    if (AuthStatus.authenticated == authProvider.authStatus) {
      return const UsersView();
    } else {
      return const LoginView();
    }
  });

  static Handler user = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.userRoute);
    if (AuthStatus.authenticated == authProvider.authStatus) {
      if (params['uid']?.first != null) {
        DataService.showNavBar = true;
        return UserView(uuid: params['uid']!.first);
      } else {
        return const UsersView();
      }
    } else {
      return const LoginView();
    }
  });

  static Handler volleyDashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.volleyDashboardRoute);
    if (AuthStatus.authenticated == authProvider.authStatus) {
      DataService.showNavBar = false;
      return DashboardVolleyView(
        authProvider: authProvider,
      );
    } else {
      return const LoginView();
    }
  });
}
