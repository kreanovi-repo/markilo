import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:markilo/domain/scoreboard/team_style.dart';
import 'package:markilo/ui/shared/scoreboard/components/team_emblem.dart';

/// Color palette shared by background and text pickers.
/// Includes white (which is missing from the default BlockPicker palette).
const List<Color> _teamPaletteColors = <Color>[
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

Future<TeamStyle?> showTeamStyleDialog(
  BuildContext context, {
  required String title,
  required TeamStyle initial,
  String fallbackAsset = 'assets/images/escudo.png',
}) async {
  Color bg = initial.backgroundColor;
  Color txt = initial.textColor;
  PlatformFile? emblem = initial.emblemFile;

  return showDialog<TeamStyle>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickEmblem() async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              withData: true,
            );
            if (result == null || result.files.isEmpty) return;
            setState(() {
              emblem = result.files.first;
            });
          }

          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      TeamEmblem(
                        size: 70,
                        fallbackAsset: fallbackAsset,
                        emblemFile: emblem,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: pickEmblem,
                          icon: const Icon(Icons.image_outlined),
                          label: const Text('Elegir escudo'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Color de fondo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 6),
                  BlockPicker(
                    pickerColor: bg,
                    availableColors: _teamPaletteColors,
                    onColorChanged: (c) => setState(() => bg = c),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Color de texto',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 6),
                  BlockPicker(
                    pickerColor: txt,
                    availableColors: _teamPaletteColors,
                    onColorChanged: (c) => setState(() => txt = c),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    TeamStyle(
                      backgroundColor: bg,
                      textColor: txt,
                      emblemFile: emblem,
                    ),
                  );
                },
                child: const Text('Aplicar'),
              ),
            ],
          );
        },
      );
    },
  );
}
