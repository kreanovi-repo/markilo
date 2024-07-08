import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:markilo/providers/user_form_provider.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/notification_service.dart';
import 'package:markilo/ui/shared/widgets/team_name.dart';
import 'package:provider/provider.dart';

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

  TeamName? localTeamName;
  TeamName? visitTeamName;

  Color backgroundColorVoley = const Color.fromARGB(255, 0, 173, 239);

  String colorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  Color stringToColor(String colorString) {
    return Color(int.parse(colorString.replaceFirst('#', ''), radix: 16));
  }

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

  void selectBackgroundColor(BuildContext context, Function updateWidget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Color de fondo - Tablero de voley'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: backgroundColorVoley,
              onColorChanged: (Color color) {
                backgroundColorVoley = color;
                updateWidget();
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Aplicar'),
              onPressed: () async {
                UserFormProvider userFormProvider =
                    Provider.of<UserFormProvider>(context, listen: false);
                DataService.user!.backgroundColorVoley =
                    colorToString(backgroundColorVoley);
                final saved =
                    await userFormProvider.updateUser(DataService.user!);
                if (saved) {
                  Navigator.of(context).pop();
                } else {
                  NotificationService.showSnackbarError(
                      'El color de fondo no pudo ser cambiado');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
