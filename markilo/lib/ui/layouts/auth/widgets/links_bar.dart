import 'package:markilo/ui/buttons/link_text.dart';
import 'package:flutter/material.dart';

class LinksBar extends StatelessWidget {
  const LinksBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: (size.width > 1000) ? size.height * 0.05 : null,
      color: Colors.black,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          LinkText(
            text: 'Sobre',
            onPressed: () => print('Sobre'),
          ),
          const LinkText(text: 'Ayuda'),
          const LinkText(text: 'Términos y condiciones'),
          const LinkText(text: 'Política de privacidad'),
          const LinkText(text: 'Política de cookies'),
          const LinkText(text: 'Advertencias'),
        ],
      ),
    );
  }
}
