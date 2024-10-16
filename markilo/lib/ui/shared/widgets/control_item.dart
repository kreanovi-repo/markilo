import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ControlItem extends StatefulWidget {
  final String text;
  bool? value;
  final Function onChanged;

  ControlItem(
      {super.key,
      required this.text,
      required this.value,
      required this.onChanged});

  @override
  State<ControlItem> createState() => _ControlItemState();
}

class _ControlItemState extends State<ControlItem> {
  bool? _valor = false;

  @override
  void initState() {
    super.initState();
    _valor = false;
    rebuildAllChildren(context);
    debugPrint(_valor.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            side: WidgetStateBorderSide.resolveWith(
              (states) => const BorderSide(width: 2.0, color: Colors.white),
            ),
            value: _valor,
            checkColor: Colors.white,
            fillColor: WidgetStateProperty.all(Colors.black),
            onChanged: (bool? value) => setState(() {
                  debugPrint(value.toString());
                  _valor = value;
                  widget.onChanged(value);
                })),
        Flexible(
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}
