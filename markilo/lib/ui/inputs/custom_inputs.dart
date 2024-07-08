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

  static InputDecoration loginInputsDecoration(
      {required String hint, required String label, required IconData icon}) {
    return InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
        hintText: hint,
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey));
  }

  static InputDecoration defaultInputsDecoration(
      {required String hint,
      required String label,
      required IconData icon,
      String? errorText}) {
    return InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        hintText: hint,
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        errorText: errorText != "" ? errorText : null);
  }

  static InputDecoration searchInputsDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey));
  }

  static InputDecoration formInputsDecoration(
      {required String hint, required String label, required String icon}) {
    return InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        hintText: hint,
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Image.asset(
            icon,
            width: 90,
          ),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey));
  }
}
