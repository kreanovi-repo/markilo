import 'package:flutter/material.dart';

class SplashLayout extends StatelessWidget {
  const SplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            const Text('Cargando. . .')
          ],
        ),
      ),
    );
  }
}
