import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreboardTeamPanel extends StatelessWidget {
  const ScoreboardTeamPanel({
    super.key,
    required this.isLeftPanel,
    required this.backgroundColor,
    required this.textColor,
    required this.centerSafeInset,
    required this.topSafeHeight,
    required this.teamNameController,
    required this.onTeamNameChanged,
    required this.score,
    required this.scoreFontFactor,
    required this.scoreBaselineFactor,
    required this.headerCenter,
    required this.headerHeight,
    required this.headerCenterWidth,
    required this.serveBoxWidth,
    required this.outerPadding,
    required this.serveVisible,
    required this.serveIcon,
    required this.onToggleServe,

    /// ✅ Opcional (Paddle lo usa en null)
    this.timeoutValues,
    this.onToggleTimeout,

    /// ✅ Opcional (Paddle lo necesita)
    this.onScoreTap,
    this.onScoreLongPress,

    /// ✅ Opcional
    this.scoreSizeMultiplier = 1.0,
    this.scoreLiftFactor = 0.0,
    this.headerOuterSlotWidth,
  });

  final bool isLeftPanel;
  final Color backgroundColor;
  final Color textColor;

  final double centerSafeInset; // se mantiene por compatibilidad
  final double topSafeHeight;

  final TextEditingController teamNameController;
  final ValueChanged<String> onTeamNameChanged;

  final int score;

  final double scoreFontFactor;
  final double scoreBaselineFactor;

  final Widget headerCenter;
  final double headerHeight;
  final double headerCenterWidth;

  final double serveBoxWidth;
  final double outerPadding;
  final bool serveVisible;
  final IconData serveIcon;
  final VoidCallback onToggleServe;

  /// ✅ Ahora opcionales (Paddle puede no usarlos)
  final List<bool>? timeoutValues;
  final ValueChanged<int>? onToggleTimeout;

  /// ✅ Vuelve el tap en el score (Paddle)
  final VoidCallback? onScoreTap;
  final VoidCallback? onScoreLongPress;

  final double scoreSizeMultiplier;
  final double scoreLiftFactor;
  final double? headerOuterSlotWidth;

  String _scoreText(int v) => v.toString().padLeft(2, '0');

  bool get _showTimeouts =>
      timeoutValues != null &&
      onToggleTimeout != null &&
      timeoutValues!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, panel) {
        final panelW = panel.maxWidth;
        final panelH = panel.maxHeight;

        final sideSlotW =
            headerOuterSlotWidth ?? (serveBoxWidth + (outerPadding * 2));

        final safeGapUnderHeader = math.max(0.0, topSafeHeight - headerHeight);

        Widget buildServeBox() {
          final boxH = headerHeight;
          final iconSize = (boxH * 0.70).clamp(50.0, 100.0);

          // Mantiene el "slot" para que el escudo no se mueva, pero
          // NO muestra la pelota en gris cuando no tiene el saque.
          return SizedBox(
            width: serveBoxWidth,
            height: headerHeight,
            child: Align(
              alignment: isLeftPanel
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onToggleServe,
                child: SizedBox(
                  width: iconSize * 1.55,
                  height: iconSize * 1.55,
                  child: Center(
                    child: serveVisible
                        ? Icon(serveIcon, size: iconSize, color: textColor)
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          );
        }

        Widget buildHeader() {
          final leftSlot = SizedBox(
            width: sideSlotW,
            height: headerHeight,
            child: Padding(
              padding: EdgeInsets.only(left: isLeftPanel ? outerPadding : 0),
              child: isLeftPanel ? buildServeBox() : const SizedBox.shrink(),
            ),
          );

          final rightSlot = SizedBox(
            width: sideSlotW,
            height: headerHeight,
            child: Padding(
              padding: EdgeInsets.only(right: !isLeftPanel ? outerPadding : 0),
              child: !isLeftPanel ? buildServeBox() : const SizedBox.shrink(),
            ),
          );

          final emblem = Expanded(
            child: SizedBox(
              height: headerHeight,
              child: Center(
                child: SizedBox(
                  width: headerCenterWidth,
                  height: headerHeight,
                  child: Center(child: headerCenter),
                ),
              ),
            ),
          );

          return SizedBox(
            height: headerHeight,
            width: panelW,
            child: Row(children: [leftSlot, emblem, rightSlot]),
          );
        }

        Widget buildTeamName() {
          final fontSize = (panelH * 0.085).clamp(28.0, 64.0);
          final style = GoogleFonts.oswald(
            color: textColor,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            fontSize: fontSize,
            height: 1.0,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: TextField(
                controller: teamNameController,
                inputFormatters: [
                  _TeamNameInputFormatter(),
                  LengthLimitingTextInputFormatter(22),
                ],
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                maxLines: 1,
                style: style,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  prefixStyle: style,
                  suffixStyle: style,
                  hintText: isLeftPanel ? 'LOCAL' : 'VISITANTE',
                  hintStyle: style.copyWith(color: textColor.withOpacity(0.70)),
                ),
                onChanged: (value) {
                  onTeamNameChanged(value);
                },
              ),
            ),
          );
        }

        Widget buildTimeouts(double areaH) {
          final circle = (areaH * 0.23).clamp(44.0, 88.0);
          final gap = (circle * 0.14).clamp(6.0, 14.0);
          final border = (circle * 0.08).clamp(3.0, 7.0);

          bool isOn(int i) =>
              (timeoutValues != null && i >= 0 && i < timeoutValues!.length)
              ? timeoutValues![i]
              : false;

          Widget dot(int i) {
            final on = isOn(i);
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onToggleTimeout?.call(i),
              child: Container(
                width: circle,
                height: circle,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: textColor, width: border),
                  color: on ? textColor.withOpacity(0.18) : Colors.transparent,
                ),
              ),
            );
          }

          return SizedBox(
            width: circle + 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                dot(0),
                SizedBox(height: gap),
                dot(1),
              ],
            ),
          );
        }

        Widget buildScoreArea() {
          return Expanded(
            child: LayoutBuilder(
              builder: (context, area) {
                final areaW = area.maxWidth;
                final areaH = area.maxHeight;

                final timeoutsW = _showTimeouts
                    ? ((areaH * 0.23).clamp(44.0, 88.0) + 2)
                    : 0.0;

                final outerReserve = timeoutsW + outerPadding;
                final innerReserve = (panelW * 0.06).clamp(22.0, 70.0);

                final leftPad = isLeftPanel ? outerReserve : innerReserve;
                final rightPad = isLeftPanel ? innerReserve : outerReserve;

                final usableW = math.max(120.0, areaW - leftPad - rightPad);
                final usableH = math.max(80.0, areaH);

                final baseFont =
                    (panelH * scoreFontFactor) * scoreSizeMultiplier;

                final capByH = usableH * 0.92;
                final capByW = usableW / 1.35;

                final fontSize = math.min(baseFont, math.min(capByH, capByW));

                final wantedLift = fontSize * scoreLiftFactor;
                final maxLift = usableH * 0.12;
                final lift = wantedLift.clamp(0.0, maxLift);

                final scoreText = _scoreText(score);

                final scoreWidget = Transform.translate(
                  offset: Offset(0, -lift),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      scoreText,
                      style: GoogleFonts.oswald(
                        color: textColor,
                        fontWeight: FontWeight.w800,
                        height: 0.92,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                );

                final tappableScore =
                    (onScoreTap != null || onScoreLongPress != null)
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: onScoreTap,
                        onLongPress: onScoreLongPress,
                        child: scoreWidget,
                      )
                    : scoreWidget;

                return Stack(
                  children: [
                    if (_showTimeouts)
                      Positioned(
                        left: isLeftPanel ? outerPadding : null,
                        right: isLeftPanel ? null : outerPadding,
                        top: 0,
                        bottom: 0,
                        child: Center(child: buildTimeouts(areaH)),
                      ),

                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: leftPad,
                          right: rightPad,
                        ),
                        child: Center(child: tappableScore),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return Container(
          color: backgroundColor,
          child: Column(
            children: [
              buildHeader(),
              SizedBox(height: safeGapUnderHeader),
              buildTeamName(),
              buildScoreArea(),
            ],
          ),
        );
      },
    );
  }
}

/// Forces team names to be uppercase and removes angle brackets.
///
/// This avoids cases like "<<LOCAL>>" when the stored value already contains
/// brackets and the UI renders its own prefix/suffix.
class _TeamNameInputFormatter extends TextInputFormatter {
  const _TeamNameInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned = newValue.text
        .replaceAll('<', '')
        .replaceAll('>', '')
        .toUpperCase();

    // Keep cursor as close as possible to where the user was editing.
    final delta = newValue.text.length - cleaned.length;
    final base = (newValue.selection.baseOffset - delta).clamp(
      0,
      cleaned.length,
    );
    final extent = (newValue.selection.extentOffset - delta).clamp(
      0,
      cleaned.length,
    );

    return newValue.copyWith(
      text: cleaned,
      selection: TextSelection(baseOffset: base, extentOffset: extent),
      composing: TextRange.empty,
    );
  }
}
