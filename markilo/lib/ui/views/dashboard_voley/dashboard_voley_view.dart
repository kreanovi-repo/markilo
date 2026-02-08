import 'package:flutter/material.dart';
import 'package:markilo/domain/scoreboard/team_side.dart';
import 'package:markilo/providers/home_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/scoreboard/cast_service.dart';
import 'package:markilo/services/scoreboard/scoreboard_share_service.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/ui/shared/scoreboard/components/match_center_panel.dart';
import 'package:markilo/ui/shared/scoreboard/components/scoreboard_split_layout.dart';
import 'package:markilo/ui/shared/scoreboard/components/scoreboard_team_panel.dart';
import 'package:markilo/ui/shared/scoreboard/components/set_marker.dart';
import 'package:markilo/ui/shared/scoreboard/components/team_emblem.dart';
import 'package:markilo/ui/shared/scoreboard/dialogs/confirm_dialog.dart';
import 'package:markilo/ui/shared/scoreboard/dialogs/team_style_dialog.dart';
import 'package:provider/provider.dart';

class DashboardVoley2View extends StatefulWidget {
  const DashboardVoley2View({super.key});

  @override
  State<DashboardVoley2View> createState() => _DashboardVoley2ViewState();
}

class _DashboardVoley2ViewState extends State<DashboardVoley2View> {
  late final TextEditingController _localController;
  late final TextEditingController _visitController;

  final GlobalKey _shareKey = GlobalKey();

  static const double _centerPanelWidthFactor = 0.25;
  static const double _centerPanelHeightFactor = 0.24;

  @override
  void initState() {
    super.initState();
    _localController = TextEditingController();
    _visitController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<HomeProvider>();
      await provider.initialize();
      _localController.text = _stripAngleBrackets(
        provider.localName,
      ).toUpperCase();
      _visitController.text = _stripAngleBrackets(
        provider.visitName,
      ).toUpperCase();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _localController.dispose();
    _visitController.dispose();
    super.dispose();
  }

  String _stripAngleBrackets(String value) {
    var v = value.trim();
    // Remove nested brackets if present (e.g. "<<LOCAL>>").
    while (v.length >= 2 && v.startsWith('<') && v.endsWith('>')) {
      v = v.substring(1, v.length - 1).trim();
    }
    // Also remove any stray brackets inside the string.
    v = v.replaceAll('<', '').replaceAll('>', '').trim();
    return v;
  }

  String _fallbackAssetForSide(TeamSide side) {
    return 'assets/images/escudo.png';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<HomeProvider>();
    final screen = MediaQuery.of(context).size;

    final centerSafeInset = (screen.width * _centerPanelWidthFactor / 2) + 5;
    final topSafeHeight = (screen.height * _centerPanelHeightFactor) - 35;

    final emblemSize = (screen.height * 0.18).clamp(140.0, 200.0);
    final headerHeight = (emblemSize + 12).clamp(150.0, 220.0);
    final headerCenterWidth = (emblemSize + 12).clamp(150.0, 220.0);

    final outerPadding = (screen.width * 0.022).clamp(16.0, 34.0);
    final serveBoxWidth = (headerHeight * 0.92).clamp(110.0, 190.0);

    final leftTeam = p.leftTeam;
    final rightTeam = p.rightTeam;

    final leftController = leftTeam == TeamSide.local
        ? _localController
        : _visitController;
    final rightController = rightTeam == TeamSide.local
        ? _localController
        : _visitController;

    final leftEmblem = TeamEmblem(
      size: emblemSize,
      padding: EdgeInsets.zero,
      fallbackAsset: _fallbackAssetForSide(leftTeam),
      emblemFile: p.leftStyle.emblemFile,
      onTap: () => p.incrementLeftScore(),
      onLongPress: () => p.decrementLeftScore(),
    );

    final rightEmblem = TeamEmblem(
      size: emblemSize,
      padding: EdgeInsets.zero,
      fallbackAsset: _fallbackAssetForSide(rightTeam),
      emblemFile: p.rightStyle.emblemFile,
      onTap: () => p.incrementRightScore(),
      onLongPress: () => p.decrementRightScore(),
    );

    Future<void> editLeftTeam() async {
      final updated = await showTeamStyleDialog(
        context,
        title: 'Configurar equipo izquierda',
        initial: p.leftStyle,
        fallbackAsset: _fallbackAssetForSide(leftTeam),
      );
      if (updated == null) return;
      await p.setTeamStyle(leftTeam, updated);
    }

    Future<void> editRightTeam() async {
      final updated = await showTeamStyleDialog(
        context,
        title: 'Configurar equipo derecha',
        initial: p.rightStyle,
        fallbackAsset: _fallbackAssetForSide(rightTeam),
      );
      if (updated == null) return;
      await p.setTeamStyle(rightTeam, updated);
    }

    Future<void> resetMatch() async {
      final ok = await showConfirmDialog(
        context,
        title: 'Reinicio del juego',
        message: '¿Estás seguro de que quieres reiniciar el juego?',
        confirmLabel: 'Reiniciar',
      );
      if (!ok) return;
      await p.resetMatch();
    }

    Future<void> swapSides() async => p.swapSides();

    return Scaffold(
      body: RepaintBoundary(
        key: _shareKey,
        child: ScoreboardSplitLayout(
          left: ScoreboardTeamPanel(
            isLeftPanel: true,
            backgroundColor: p.leftStyle.backgroundColor,
            textColor: p.leftStyle.textColor,
            centerSafeInset: centerSafeInset,
            topSafeHeight: topSafeHeight,
            teamNameController: leftController,
            onTeamNameChanged: (v) => p.setTeamName(leftTeam, v),
            score: p.leftScore,

            // Base (la pantalla buena que ya tenías)
            scoreFontFactor: 0.53,
            scoreBaselineFactor: 0.42,

            // ✅ PEDIDO: +10% tamaño / +20% arriba (controlado y sin overflow)
            scoreSizeMultiplier: 1.10,
            scoreLiftFactor: 0.20,
            headerCenter: leftEmblem,
            headerHeight: headerHeight,
            headerCenterWidth: headerCenterWidth,
            serveBoxWidth: serveBoxWidth,
            outerPadding: outerPadding,
            serveVisible: p.serveOnLeft,
            serveIcon: Icons.sports_volleyball,
            onToggleServe: () => p.toggleServe(),
            timeoutValues: p.leftTimeouts,
            onToggleTimeout: (i) => p.toggleLeftTimeout(i),
          ),
          right: ScoreboardTeamPanel(
            isLeftPanel: false,
            backgroundColor: p.rightStyle.backgroundColor,
            textColor: p.rightStyle.textColor,
            centerSafeInset: centerSafeInset,
            topSafeHeight: topSafeHeight,
            teamNameController: rightController,
            onTeamNameChanged: (v) => p.setTeamName(rightTeam, v),
            score: p.rightScore,

            scoreFontFactor: 0.55,
            scoreBaselineFactor: 0.42,

            // ✅ PEDIDO
            scoreSizeMultiplier: 1.10,
            scoreLiftFactor: 0.20,

            headerCenter: rightEmblem,
            headerHeight: headerHeight,
            headerCenterWidth: headerCenterWidth,
            serveBoxWidth: serveBoxWidth,
            outerPadding: outerPadding,
            serveVisible: p.serveOnRight,
            serveIcon: Icons.sports_volleyball,
            onToggleServe: () => p.toggleServe(),
            timeoutValues: p.rightTimeouts,
            onToggleTimeout: (i) => p.toggleRightTimeout(i),
          ),
          topOverlay: MatchCenterPanel(
            panelWidthFactor: _centerPanelWidthFactor,
            panelHeightFactor: _centerPanelHeightFactor,
            onEditLeftTeam: editLeftTeam,
            onEditRightTeam: editRightTeam,
            onCast: () => CastService.openCastSettings(),
            onHome: () => NavigationService.replaceTo(Flurorouter.homeRoute),
            onResetMatch: resetMatch,
            onSwapSides: swapSides,
            onShare: () => ScoreboardShareService.shareScoreboard(
              _shareKey,
              text: 'Marcador Vóley',
            ),
          ),
          bottomOverlay: SetMarker(
            leftValue: p.leftSets,
            rightValue: p.rightSets,
            leftColor: p.leftStyle.textColor,
            rightColor: p.rightStyle.textColor,
            onTapLeft: () => p.incrementSets(leftTeam),
            onLongPressLeft: () => p.decrementSets(leftTeam),
            onTapRight: () => p.incrementSets(rightTeam),
            onLongPressRight: () => p.decrementSets(rightTeam),
          ),
        ),
      ),
    );
  }
}
