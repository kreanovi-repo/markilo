import 'package:flutter/material.dart';

class CustomInputs {
  static InputDecoration invisibleInput() {
    return const InputDecoration(
      border:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
    );
  }
}
