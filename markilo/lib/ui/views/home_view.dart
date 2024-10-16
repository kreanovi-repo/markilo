import 'package:markilo/providers/auth_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:markilo/ui/labels/custom_labels.dart';
import 'package:markilo/ui/shared/widgets/home_shortcut.dart';
import 'package:markilo/ui/shared/widgets/navbar_avatar.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool loading = false;
  final TextEditingController orderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        buildNavBar(authProvider),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.3),
            child: HomeShortcut(
                title: 'Tablero de Voley',
                iconImage: 'assets/images/voley.png',
                route: Flurorouter.volleyDashboardRoute,
                subTitle: 'Ver tablero'),
          ),
        )
      ],
    );
  }

  AppBar buildNavBar(AuthProvider authProvider) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 1, 50, 75),
      toolbarHeight: 60,
      title: Row(
        children: [
          const Spacer(),
          if (size.width > 330)
            Text(
              "Hola ${authProvider.user!.name}!",
              style: CustomLabels.h4.copyWith(color: Colors.white),
            ),
          const SizedBox(
            width: 5,
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () =>
                  NavigationService.replaceTo(Flurorouter.profileRoute),
              child: const NavbarAvatar(size: 60)),
        ],
      ),
    );
  }
}
