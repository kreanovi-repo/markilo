import 'package:flutter/material.dart';

class SideMenuProvider extends ChangeNotifier {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _currentPage = '';
  String get currentPage {
    return _currentPage;
  }

  void setCurrentPageUrl(String routeName) {
    _currentPage = routeName;
    Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
