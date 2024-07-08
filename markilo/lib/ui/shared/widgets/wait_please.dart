import 'package:flutter/material.dart';

class WaitPlease extends StatelessWidget {
  const WaitPlease({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: const Text(
            "Aguarde por favor . . .",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
