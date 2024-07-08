import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhiteCard extends StatelessWidget {
  final double? width;
  final String? title;
  final IconData? icon;
  final Widget child;

  const WhiteCard(
      {super.key, this.title, required this.child, this.width, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      decoration: buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (null != title) ...[
            FittedBox(
              fit: BoxFit.contain,
              child: Row(
                children: [
                  icon != null ? Icon(icon) : const SizedBox(),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title!,
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
          child
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
          ]);
}
