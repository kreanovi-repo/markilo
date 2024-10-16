import 'package:markilo/types/constants.dart';
import 'package:markilo/ui/layouts/auth/widgets/auth_background.dart';
import 'package:markilo/ui/layouts/auth/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:markilo/ui/layouts/auth/widgets/links_bar.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Scrollbar(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          if (size.width > Constants.minDesktopWidth)
            _DesktopBody(
              child: child,
            )
          else
            _MobileBody(
              child: child,
            ),
          // LinksBar
          const LinksBar(),
        ],
      ),
    ));
  }
}

class _DesktopBody extends StatelessWidget {
  const _DesktopBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.95,
      color: Colors.black,
      child: Row(
        children: [
          // Auth background
          const AuthBackground(),
          // Login container
          Container(
            width: 600,
            height: size.height * 0.95,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CustomTitle(),
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: child),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  const _MobileBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.95,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const CustomTitle(),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              //height: 500,
              child: child,
            ),
          ),
          //Spacer(),
          /*Container(
            width: double.infinity,
            height: 400,
            child: AuthBackground(),
          )*/
        ],
      ),
    );
  }
}
