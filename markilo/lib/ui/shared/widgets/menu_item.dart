import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarMenuItem extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isActive;
  final Function onPressed;

  const SidebarMenuItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<SidebarMenuItem> createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<SidebarMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorMenuItem = Colors.white.withOpacity(0.1);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: isHovered
          ? colorMenuItem
          : widget.isActive
              ? colorMenuItem
              : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isActive ? null : () => widget.onPressed(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.text,
                    style: GoogleFonts.roboto(
                        fontSize: 16, color: Colors.white.withOpacity(0.8)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
