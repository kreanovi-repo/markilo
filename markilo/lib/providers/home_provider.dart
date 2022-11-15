import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool localServe = true;
  int scoreLeft = 0;
  int scoreRight = 0;
  int setLeft = 0;
  int setRight = 0;

  bool localTime1Used = false;
  bool localTime2Used = false;

  bool visitTime1Used = false;
  bool visitTime2Used = false;

  Widget? localEmblem;
  Widget? visitEmblem;

  toggleServe() {
    localServe = !localServe;
    notifyListeners();
  }

  toggleLocalTime1() {
    localTime1Used = !localTime1Used;
    notifyListeners();
  }

  toggleLocalTime2() {
    localTime2Used = !localTime2Used;
    notifyListeners();
  }

  toggleVisitTime1() {
    visitTime1Used = !visitTime1Used;
    notifyListeners();
  }

  toggleVisitTime2() {
    visitTime2Used = !visitTime2Used;
    notifyListeners();
  }

  resetValues() {
    localServe = true;
    scoreLeft = 0;
    scoreRight = 0;
    localTime1Used = false;
    localTime2Used = false;
    visitTime1Used = false;
    visitTime2Used = false;
    notifyListeners();
  }

  resetSets() {
    setLeft = 0;
    setRight = 0;
    notifyListeners();
  }
}
