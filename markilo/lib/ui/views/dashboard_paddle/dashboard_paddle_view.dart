import 'package:flutter/material.dart';
import 'package:markilo/domain/scoreboard/team_side.dart';
import 'package:markilo/providers/paddle/paddle_provider.dart';
import 'package:markilo/router/router.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/services/scoreboard/cast_service.dart';
import 'package:markilo/services/scoreboard/scoreboard_share_service.dart';
import 'package:markilo/ui/shared/scoreboard/components/match_center_panel.dart';
import 'package:markilo/ui/shared/scoreboard/components/scoreboard_split_layout.dart';
import 'package:markilo/ui/shared/scoreboard/components/scoreboard_team_panel.dart';
import 'package:markilo/ui/shared/scoreboard/components/set_marker.dart';
import 'package:markilo/ui/shared/scoreboard/dialogs/confirm_dialog.dart';
import 'package:markilo/ui/shared/scoreboard/dialogs/team_style_dialog.dart';
import 'package:provider/provider.dart';

class DashboardPaddleView extends StatefulWidget {
  const DashboardPaddleView({super.key});

  @override
  State<DashboardPaddleView> createState() => _DashboardPaddleViewState();
}

class _DashboardPaddleViewState extends State<DashboardPaddleView> {
  late final TextEditingController _localController;
  late final TextEditingController _visitController;

  final GlobalKey _shareKey = GlobalKey();

  static const double _centerPanelWidthFactor = 0.25;
  static const double _centerPanelHeightFactor = 0.24;

  String _stripAngleBrackets(String value) {
    var v = value.trim();
    while (v.length >= 2 && v.startsWith('<') && v.endsWith('>')) {
      v = v.substring(1, v.length - 1).trim();
    }
    return v;
  }

  @override
  void initState() {
    super.initState();
    _localController = TextEditingController();
    _visitController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p = context.read<PaddleProvider>();
      await p.initialize();
      _localController.text = _stripAngleBrackets(p.localName).toUpperCase();
      _visitController.text = _stripAngleBrackets(p.visitName).toUpperCase();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _localController.dispose();
    _visitController.dispose();
    super.dispose();
  }

  String _fallbackAssetForSide(TeamSide side) {
    return side == TeamSide.local
        ? 'assets/images/escudo.png'
        : 'assets/images/escudo_negro.png';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PaddleProvider>();
    final screen = MediaQuery.of(context).size;

    final centerSafeInset = (screen.width * _centerPanelWidthFactor / 2) + 8;
    final topSafeHeight = (screen.height * _centerPanelHeightFactor) - 35;

    // Header sizes (similares a vóley, un toque más chico para paddle)
    final emblemSize = (screen.height * 0.15).clamp(120.0, 180.0);
    final headerHeight = (emblemSize + 10).clamp(135.0, 210.0);
    final headerCenterWidth = (emblemSize + 10).clamp(135.0, 210.0);

    final outerPadding = (screen.width * 0.022).clamp(16.0, 34.0);
    final serveBoxWidth = (headerHeight * 0.88).clamp(105.0, 180.0);

    final leftTeam = p.leftTeam;
    final rightTeam = p.rightTeam;

    final leftController = leftTeam == TeamSide.local
        ? _localController
        : _visitController;
    final rightController = rightTeam == TeamSide.local
        ? _localController
        : _visitController;

    Future<void> editLeftTeam() async {
      final updated = await showTeamStyleDialog(
        context,
        title: 'Configuración equipo izquierda',
        initial: p.leftStyle,
        fallbackAsset: _fallbackAssetForSide(leftTeam),
      );
      if (updated != null) {
        await p.setTeamStyle(leftTeam, updated);
      }
    }

    Future<void> editRightTeam() async {
      final updated = await showTeamStyleDialog(
        context,
        title: 'Configuración equipo derecha',
        initial: p.rightStyle,
        fallbackAsset: _fallbackAssetForSide(rightTeam),
      );
      if (updated != null) {
        await p.setTeamStyle(rightTeam, updated);
      }
    }

    Future<void> resetMatch() async {
      final ok = await showConfirmDialog(
        context,
        title: 'Reinicio del juego',
        message: '¿Estás seguro de que quieres reiniciar el juego?',
        confirmLabel: 'Reiniciar',
      );
      if (ok) {
        await p.resetMatch();
        await p.resetSets();
      }
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
            onTeamNameChanged: (value) => p.setTeamName(leftTeam, value),

            score: p.leftScore,
            onScoreTap: () => p.incrementLeftScore(),
            onScoreLongPress: () => p.decrementLeftScore(),

            scoreFontFactor: 0.50,
            scoreBaselineFactor: 0.42,

            // Paddle no usa escudo centrado arriba en este diseño
            headerCenter: const SizedBox.shrink(),
            headerHeight: headerHeight,
            headerCenterWidth: headerCenterWidth,

            serveBoxWidth: serveBoxWidth,
            outerPadding: outerPadding,
            serveVisible: p.serveOnLeft,
            serveIcon: Icons.sports_tennis_outlined,
            onToggleServe: () => p.toggleServe(),

            // ✅ NO timeouts (ya no rompe)
            timeoutValues: null,
            onToggleTimeout: null,
          ),
          right: ScoreboardTeamPanel(
            isLeftPanel: false,
            backgroundColor: p.rightStyle.backgroundColor,
            textColor: p.rightStyle.textColor,
            centerSafeInset: centerSafeInset,
            topSafeHeight: topSafeHeight,
            teamNameController: rightController,
            onTeamNameChanged: (value) => p.setTeamName(rightTeam, value),

            score: p.rightScore,
            onScoreTap: () => p.incrementRightScore(),
            onScoreLongPress: () => p.decrementRightScore(),

            scoreFontFactor: 0.50,
            scoreBaselineFactor: 0.42,

            headerCenter: const SizedBox.shrink(),
            headerHeight: headerHeight,
            headerCenterWidth: headerCenterWidth,

            serveBoxWidth: serveBoxWidth,
            outerPadding: outerPadding,
            serveVisible: p.serveOnRight,
            serveIcon: Icons.sports_tennis_outlined,
            onToggleServe: () => p.toggleServe(),

            timeoutValues: null,
            onToggleTimeout: null,
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
              text: 'Marcador Paddle',
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
