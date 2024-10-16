import 'package:markilo/models/user.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/ui/cards/white_card.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.90;
    if (MediaQuery.of(context).size.width > 500) {
      width = 400;
    }
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            IconButton(
                alignment: Alignment.topLeft,
                onPressed: () {
                  NavigationService.replaceTo(Flurorouter.homeRoute);
                },
                icon: const Icon(Icons.arrow_back_outlined)),
            const Spacer()
          ],
        ),
        Image.asset(
          'assets/images/logo_blanco.png',
          width: 250,
        ),
        const SizedBox(
          height: 15,
        ),
        WhiteCard(
            title: 'Información personal',
            width: width,
            child: Column(
              children: [
                ItemProfile(
                  title: 'Nombre y Apellido',
                  value: Text(
                    "${user.name} ${user.surname}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ItemProfile(
                  title: 'E-mail',
                  value: Text(
                    user.email,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                /*ItemProfile(
                    title: 'Contraseña',
                    value: ElevatedButton(
                      onPressed: () {
                        NavigationService.replaceTo(
                            Flurorouter.passwordChangeRoute);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      child: const Text('Cambiar'),
                    )),*/
              ],
            )),
        const SizedBox(
          height: 15,
        ),
      ]),
    );
  }
}

class ItemProfile extends StatelessWidget {
  const ItemProfile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        value
      ],
    );
  }
}
