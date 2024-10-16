import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 140,
            height: 100,
            child: Image.asset('assets/images/logo_blanco.png')),
      ],
    );
  }
}
