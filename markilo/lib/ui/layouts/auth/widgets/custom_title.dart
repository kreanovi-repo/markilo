import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Image.asset(
          'assets/images/logo_blanco.png',
          width: 250,
          height: 100,
        ),
      ],
    );
  }
}
