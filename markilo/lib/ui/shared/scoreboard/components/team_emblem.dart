import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TeamEmblem extends StatelessWidget {
  const TeamEmblem({
    super.key,
    required this.size,
    required this.fallbackAsset,
    this.emblemFile,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.onLongPress,
  });

  final double size;
  final String fallbackAsset;
  final PlatformFile? emblemFile;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final bytes = emblemFile?.bytes;

    final image = (bytes != null && bytes.isNotEmpty)
        ? Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.contain,
            // Helps on low-end tablets
            cacheWidth: size.round(),
            cacheHeight: size.round(),
          )
        : Image.asset(
            fallbackAsset,
            width: size,
            height: size,
            fit: BoxFit.contain,
            cacheWidth: size.round(),
            cacheHeight: size.round(),
          );

    final wrapped = Padding(padding: padding, child: image);

    if (onTap == null && onLongPress == null) {
      return wrapped;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: wrapped,
    );
  }
}
