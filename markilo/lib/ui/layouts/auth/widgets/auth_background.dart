import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: _buildBoxDecoration(),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                  ),
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    String bgImage = 'assets/images/bg-auth.jpg';
    return BoxDecoration(
        image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover));
  }
}
