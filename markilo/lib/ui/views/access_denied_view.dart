import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/ui/buttons/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset(
              'assets/warning.png',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            'El usuario registrado no tiene permitido el acceso a esta sección',
            style: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          )),
          const SizedBox(
            height: 20,
          ),
          CustomOutlinedButton(
              onPressed: () {
                NavigationService.navigateTo(Flurorouter.homeRoute);
              },
              text: 'Volver')
        ],
      ),
    );
  }
}
