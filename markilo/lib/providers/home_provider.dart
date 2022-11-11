import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool localServe = true;
  int scoreLeft = 0;
  int scoreRight = 0;

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

  setLocalTime1AsUsed() {
    localTime1Used = true;
    notifyListeners();
  }

  setLocalTime2AsUsed() {
    localTime2Used = true;
    notifyListeners();
  }

  setVisitTime1AsUsed() {
    visitTime1Used = true;
    notifyListeners();
  }

  setVisitTime2AsUsed() {
    visitTime2Used = true;
    notifyListeners();
  }

  updateListener() {
    //notifyListeners();
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
}
