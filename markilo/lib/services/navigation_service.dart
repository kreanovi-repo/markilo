import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static navigateTo(String routeName) {
    /*Future.delayed(Duration(milliseconds: 0), () {
      return navigatorKey.currentState!.pushNamed(routeName);
    });*/
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static replaceTo(String routeName) {
    /*Future.delayed(Duration(milliseconds: 100), () {
      return navigatorKey.currentState!.pushReplacementNamed(routeName);
    });*/
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }
}
