import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markilo/ui/inputs/custom_inputs.dart';

class TeamName extends StatelessWidget {
  const TeamName({
    super.key,
    required TextEditingController? controller,
    required this.color,
  }) : _controller = controller;

  final TextEditingController? _controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.35,
      child: TextField(
          textAlign: TextAlign.center,
          controller: _controller,
          style: GoogleFonts.oswald(
            fontSize: size.width * 0.045,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          decoration: CustomInputs.invisibleInput()),
    );
  }
}
