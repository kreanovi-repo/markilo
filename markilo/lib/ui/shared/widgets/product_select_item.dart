import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSelectItem extends StatelessWidget {
  final String text;
  final String image;
  final Function onTap;

  const ProductSelectItem(
      {super.key, required this.text, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
          width: 200,
          child: Column(
            children: [
              Image.asset(image),
              Text(
                text,
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
