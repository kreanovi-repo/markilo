import 'package:flutter/material.dart';

class WaitPlease extends StatelessWidget {
  const WaitPlease({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Aguarde por favor . . .",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
