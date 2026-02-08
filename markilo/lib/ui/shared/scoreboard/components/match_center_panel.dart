import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markilo/services/scoreboard/cast_service.dart';
import 'package:markilo/ui/shared/scoreboard/dialogs/confirm_dialog.dart';
import 'package:markilo/ui/shared/scoreboard/utils/fullscreen_service.dart';

class MatchCenterPanel extends StatefulWidget {
  const MatchCenterPanel({
    super.key,
    required this.panelWidthFactor,
    required this.panelHeightFactor,
    required this.onEditLeftTeam,
    required this.onEditRightTeam,
    required this.onHome,
    required this.onResetMatch,
    required this.onSwapSides,
    this.onCast, // lo dejamos por compatibilidad
    this.onShare,
  });

  final double panelWidthFactor;
  final double panelHeightFactor;

  final Future<void> Function() onEditLeftTeam;
  final Future<void> Function() onEditRightTeam;
  final VoidCallback onHome;
  final Future<void> Function() onResetMatch;
  final Future<void> Function() onSwapSides;

  /// Opcional: si te lo pasan, lo usamos como fallback (mantiene compatibilidad).
  final FutureOr<void> Function()? onCast;

  final FutureOr<void> Function()? onShare;

  @override
  State<MatchCenterPanel> createState() => _MatchCenterPanelState();
}

class _MatchCenterPanelState extends State<MatchCenterPanel> {
  bool _running = false;
  int _seconds = 0;
  Timer? _timer;

  /// ⚠️ Estado "manual" para icono (sin Kotlin no hay estado real).
  bool _castConnectedUi = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  String get _timerText {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _resetTimerWithConfirm() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Reinicio de temporizador',
      message: '¿Estás seguro de que quieres reiniciar el temporizador?',
      confirmLabel: 'Reiniciar',
    );
    if (!ok) return;

    setState(() {
      _running = false;
      _seconds = 0;
    });
    _stop();
  }

  Future<void> _callFutureOrVoid(FutureOr<void> Function()? fn) async {
    if (fn == null) return;
    await Future.sync(() => fn());
  }

  Future<void> _handleCastPressed() async {
    // Si tenés implementada la apertura de settings en CastService, la usamos.
    // Si no, cae al callback onCast que ya estabas usando.
    if (!_castConnectedUi) {
      final ok = await showConfirmDialog(
        context,
        title: 'Chromecast',
        message:
            'Se abrirá el selector del sistema para elegir un dispositivo.\n\n'
            'Cuando termines de conectar, volvé a la app.',
        confirmLabel: 'Abrir',
      );
      if (!ok) return;

      bool opened = false;
      try {
        opened = await CastService.openCastSettings();
      } catch (_) {
        opened = false;
      }

      if (!opened && widget.onCast != null) {
        await _callFutureOrVoid(widget.onCast);
      }

      if (mounted) {
        // ✅ estado manual: asumimos que el usuario conectó (podés cambiarlo si querés)
        setState(() => _castConnectedUi = true);
      }
      return;
    }

    // Desconectar (manual): confirm + abrir settings
    final ok = await showConfirmDialog(
      context,
      title: 'Desconectar',
      message:
          'Para desconectarte se abrirá el panel del sistema.\n\n'
          '¿Quieres continuar?',
      confirmLabel: 'Desconectar',
    );
    if (!ok) return;

    bool opened = false;
    try {
      opened = await CastService.openCastSettings();
    } catch (_) {
      opened = false;
    }

    if (!opened && widget.onCast != null) {
      await _callFutureOrVoid(widget.onCast);
    }

    if (mounted) {
      // ✅ estado manual: marcamos desconectado
      setState(() => _castConnectedUi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final w = screen.width * widget.panelWidthFactor;
    final h = screen.height * widget.panelHeightFactor;

    final iconSize = (h * 0.28).clamp(34.0, 50.0);

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                SizedBox(
                  width: iconSize + 12,
                  child: IconButton(
                    icon: Icon(
                      _running ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        _running = !_running;
                        if (_running) {
                          _start();
                        } else {
                          _stop();
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _timerText,
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: h * 0.62,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: iconSize + 12,
                  child: IconButton(
                    icon: Icon(
                      Icons.restore_outlined,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: _resetTimerWithConfirm,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<int>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: (h * 0.22).clamp(28.0, 44.0),
            ),
            offset: const Offset(-85, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.grey[850],
            itemBuilder: (menuContext) => [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await widget.onEditLeftTeam();
                        if (mounted) Navigator.pop(menuContext);
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () async {
                        await FullscreenService.toggle();
                        if (mounted) Navigator.pop(menuContext);
                      },
                      icon: Icon(
                        FullscreenService.isFullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                    ),

                    // ✅ CAST: NO navega. Popup + abre settings.
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(menuContext);
                        await _handleCastPressed();
                      },
                      icon: Icon(
                        _castConnectedUi
                            ? Icons.cast_connected
                            : Icons.cast_outlined,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        await widget.onEditRightTeam();
                        if (mounted) Navigator.pop(menuContext);
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(menuContext, rootNavigator: true).pop();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.onHome();
                        });
                      },
                      icon: const Icon(Icons.home, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(menuContext);
                        await widget.onResetMatch();
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(menuContext);
                        await widget.onSwapSides();
                      },
                      icon: const Icon(
                        Icons.compare_arrows,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(menuContext);
                        await _callFutureOrVoid(widget.onShare);
                      },
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (_) {},
          ),
        ],
      ),
    );
  }
}
