import 'package:flutter/material.dart';

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbarError(String message) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red.withOpacity(0.9),
        content:
            Text(message, style: const TextStyle(color: Colors.white, fontSize: 20)));

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static void showSnackbar(String message) {
    final snackBar = SnackBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
        content:
            Text(message, style: const TextStyle(color: Colors.black, fontSize: 20)));

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static void showBusyIndicator(BuildContext context) {
    const AlertDialog dialog = AlertDialog(
      content: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text('Aguarde por favor . . .')
            ],
          ),
        ),
      ),
    );

    showDialog(context: context, builder: (_) => dialog);
  }
}
