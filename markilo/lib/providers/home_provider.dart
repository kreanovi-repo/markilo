import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:markilo/models/configuration/team/team_configuration.dart';
import 'package:markilo/services/local_storage.dart';
import 'package:markilo/types/constants.dart';
import 'package:markilo/ui/shared/widgets/team_name.dart';

class HomeProvider extends ChangeNotifier {
  bool localServe = true;
  int _scoreLeft = 0;
  int _scoreRight = 0;
  int _setLeft = 0;
  int _setRight = 0;

  bool localEmblemLeft = true;

  bool localTime1Used = false;
  bool localTime2Used = false;

  bool visitTime1Used = false;
  bool visitTime2Used = false;

  Widget? localEmblem;
  Widget? visitEmblem;

  TeamName? localTeamName;
  TeamName? visitTeamName;

  Color localBackgroundColor = Colors.red;
  Color localTextColor = Colors.white;
  Color visitBackgroundColor = Colors.black;
  Color visitTextColor = Colors.white;

  PlatformFile? localEmblemFile;
  PlatformFile? visitEmblemFile;

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
    _scoreLeft = 0;
    _scoreRight = 0;
    localTime1Used = false;
    localTime2Used = false;
    visitTime1Used = false;
    visitTime2Used = false;
    notifyListeners();
  }

  resetSets() {
    _setLeft = 0;
    _setRight = 0;
    notifyListeners();
  }

  int get scoreLeft => _scoreLeft;
  int get scoreRight => _scoreRight;
  int get setLeft => _setLeft;
  int get setRight => _setRight;

  set scoreLeft(int value) {
    _scoreLeft = value;
    notifyListeners();
  }

  set scoreRight(int value) {
    _scoreRight = value;
    notifyListeners();
  }

  set setLeft(int value) {
    _setLeft = value;
    notifyListeners();
  }

  set setRight(int value) {
    _setRight = value;
    notifyListeners();
  }

  incrementScoreLeft() {
    ++_scoreLeft;
    LocalStorage.prefs.setInt(Constants.scoreLeftValue, _scoreLeft);
    notifyListeners();
  }

  decrementScoreLeft() {
    if (_scoreLeft > 0) {
      --_scoreLeft;
      LocalStorage.prefs.setInt(Constants.scoreLeftValue, _scoreLeft);
      notifyListeners();
    }
  }

  incrementScoreRight() {
    ++_scoreRight;
    LocalStorage.prefs.setInt(Constants.scoreRightValue, _scoreRight);
    notifyListeners();
  }

  decrementScoreRight() {
    if (_scoreRight > 0) {
      --_scoreRight;
      LocalStorage.prefs.setInt(Constants.scoreRightValue, _scoreRight);
      notifyListeners();
    }
  }

  incrementSetLeft() {
    ++_setLeft;
    LocalStorage.prefs.setInt(Constants.setLeftValue, _setLeft);
    notifyListeners();
  }

  decrementSetLeft() {
    if (_setLeft > 0) {
      --_setLeft;
      LocalStorage.prefs.setInt(Constants.setLeftValue, _setLeft);
      notifyListeners();
    }
  }

  incrementSetRight() {
    ++_setRight;
    LocalStorage.prefs.setInt(Constants.setRightValue, _setRight);
    notifyListeners();
  }

  decrementSetRight() {
    if (_setRight > 0) {
      --_setRight;
      LocalStorage.prefs.setInt(Constants.setRightValue, _setRight);
      notifyListeners();
    }
  }

  saveLocalTeamName(String localTeamName) {
    LocalStorage.prefs.setString(Constants.localTeamNameValue, localTeamName);
    notifyListeners();
  }

  saveVisitTeamName(String visitTeamName) {
    LocalStorage.prefs.setString(Constants.visitTeamNameValue, visitTeamName);
    notifyListeners();
  }

  Future<void> showColorPickerDialog(
      BuildContext context, bool localSelect) async {
    PlatformFile? tempEmblemFile = localEmblemFile;
    Color tempBackgroundColor = localBackgroundColor;
    Color tempTextColor = localTextColor;
    if (!localSelect) {
      tempBackgroundColor = visitBackgroundColor;
      tempTextColor = visitTextColor;
      tempEmblemFile = visitEmblemFile;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Configuración de colores'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Color de fondo'),
                ColorPicker(
                  pickerColor: tempBackgroundColor,
                  onColorChanged: (color) {
                    tempBackgroundColor = color;
                  },
                  enableAlpha: false,
                  pickerAreaHeightPercent: 0.25,
                  displayThumbColor: true,
                ),
                const SizedBox(height: 10),
                const Text('Color del texto'),
                ColorPicker(
                  pickerColor: tempTextColor,
                  onColorChanged: (color) {
                    tempTextColor = color;
                  },
                  enableAlpha: false,
                  pickerAreaHeightPercent: 0.25,
                  displayThumbColor: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      children: [
                        const Text('Seleccione el escudo'),
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              tempEmblemFile = result.files.first;
                            }
                          },
                          child: const Text('Seleccionar escudo'),
                        ),
                      ],
                    ),
                    tempEmblemFile != null
                        ? Image.memory(
                            tempEmblemFile!.bytes!,
                            width: 100,
                            height: 100,
                          )
                        : Image.asset(
                            'assets/images/escudo_negro.png',
                            width: 100,
                            height: 100,
                          ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (localSelect) {
                  localBackgroundColor = tempBackgroundColor;
                  localTextColor = tempTextColor;
                  localEmblemFile = tempEmblemFile;
                  final config = TeamConfiguration(
                    platformFile: tempEmblemFile!,
                    backgroundColor: localBackgroundColor,
                    textColor: localTextColor,
                  );
                  await saveConfigurationLocalToStorage(config, true);
                } else {
                  visitBackgroundColor = tempBackgroundColor;
                  visitTextColor = tempTextColor;
                  visitEmblemFile = tempEmblemFile;
                  final config = TeamConfiguration(
                    platformFile: visitEmblemFile!,
                    backgroundColor: visitBackgroundColor,
                    textColor: visitTextColor,
                  );
                  await saveConfigurationLocalToStorage(config, false);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveConfigurationLocalToStorage(
      TeamConfiguration config, bool localTeam) async {
    final configMap = config.toJson();

    if (localTeam) {
      await LocalStorage.prefs
          .setString(Constants.teamLocalLogo, configMap['logo']!);
      await LocalStorage.prefs.setString(
          Constants.teamLocalBackgroundColor, configMap['backgroundColor']!);
      await LocalStorage.prefs
          .setString(Constants.teamLocalTextColor, configMap['textColor']!);
    } else {
      await LocalStorage.prefs
          .setString(Constants.teamVisitLogo, configMap['logo']!);
      await LocalStorage.prefs.setString(
          Constants.teamVisitBackgroundColor, configMap['backgroundColor']!);
      await LocalStorage.prefs
          .setString(Constants.teamVisitTextColor, configMap['textColor']!);
    }
  }

  Future<TeamConfiguration?> loadConfigurationFromStorage(
      bool localTeam) async {
    String? logo = LocalStorage.prefs.getString(Constants.teamLocalLogo);
    String? backgroundColor =
        LocalStorage.prefs.getString(Constants.teamLocalBackgroundColor);
    String? textColor =
        LocalStorage.prefs.getString(Constants.teamLocalTextColor);

    if (!localTeam) {
      logo = LocalStorage.prefs.getString(Constants.teamVisitLogo);
      backgroundColor =
          LocalStorage.prefs.getString(Constants.teamVisitBackgroundColor);
      textColor = LocalStorage.prefs.getString(Constants.teamVisitTextColor);
    }

    if (logo != null && backgroundColor != null && textColor != null) {
      return TeamConfiguration.fromJson({
        'logo': logo,
        'backgroundColor': backgroundColor,
        'textColor': textColor,
      });
    }
    return null; // Si no hay configuración guardada
  }

  /*Future<Uint8List?> loadImageLocalTeamFromLocalStorage() async {
    String? base64Image = LocalStorage.prefs.getString(Constants.teamLocalLogo);
    if (base64Image != null) {
      Uint8List imageBytes = base64Decode(base64Image);
      return imageBytes;
    }
    return null;
  }

  Future<Color?> loadBackgroundColorFromLocalStorage() async {
    String? backgroundColor =
        LocalStorage.prefs.getString(Constants.teamLocalBackgroundColor);
    if (backgroundColor != null) {
      return Color(int.parse(backgroundColor, radix: 16));
    }
    return null;
  }

  Future<Color?> loadTextColorFromLocalStorage() async {
    String? textColor =
        LocalStorage.prefs.getString(Constants.teamLocalTextColor);
    if (textColor != null) {
      return Color(int.parse(textColor, radix: 16));
    }
    return null;
  }*/
}
