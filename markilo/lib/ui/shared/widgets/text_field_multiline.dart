import 'package:flutter/material.dart';
import 'package:markilo/ui/inputs/custom_inputs.dart';

class TextFieldMultiline extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onChanged;
  final TextEditingController controller;

  const TextFieldMultiline(
      {super.key,
      required this.label,
      required this.icon,
      required this.onChanged,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: null,
        autocorrect: true,
        keyboardType: TextInputType.multiline,
        decoration: CustomInputs.defaultInputsDecoration(
            hint: label, label: label, icon: icon),
        onChanged: (value) => onChanged(value));
  }
}
