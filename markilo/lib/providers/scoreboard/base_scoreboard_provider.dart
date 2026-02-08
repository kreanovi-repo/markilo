import 'package:flutter/material.dart';
import 'package:markilo/domain/scoreboard/score_rule.dart';
import 'package:markilo/domain/scoreboard/sport.dart';
import 'package:markilo/domain/scoreboard/team_side.dart';
import 'package:markilo/domain/scoreboard/team_style.dart';
import 'package:markilo/services/scoreboard/scoreboard_prefs.dart';

/// Base provider used by all sport dashboards.
///
/// - No widgets stored here.
/// - Only data + callbacks.
/// - All persistence is namespaced per [sport].
abstract class BaseScoreboardProvider extends ChangeNotifier {
  BaseScoreboardProvider({
    required this.sport,
    required this.scoreRule,
    required String defaultLocalName,
    required String defaultVisitName,
    required TeamStyle defaultLocalStyle,
    required TeamStyle defaultVisitStyle,
  }) : _defaultLocalName = defaultLocalName,
       _defaultVisitName = defaultVisitName,
       _defaultLocalStyle = defaultLocalStyle,
       _defaultVisitStyle = defaultVisitStyle,
       _prefs = ScoreboardPrefs(sport) {
    // ✅ Importante: valores por defecto inmediatos para evitar LateInitializationError
    // si alguna UI lee estilos antes de que termine initialize().
    localName = _defaultLocalName.toUpperCase();
    visitName = _defaultVisitName.toUpperCase();
    localStyle = _defaultLocalStyle;
    visitStyle = _defaultVisitStyle;
  }

  final Sport sport;
  final ScoreRule scoreRule;
  final ScoreboardPrefs _prefs;

  final String _defaultLocalName;
  final String _defaultVisitName;
  final TeamStyle _defaultLocalStyle;
  final TeamStyle _defaultVisitStyle;

  bool _initialized = false;

  // Orientation
  bool localOnLeft = true;
  bool localServe = true;

  // Scores / sets (stored by team, not by side)
  int localScore = 0;
  int visitScore = 0;
  int localSets = 0;
  int visitSets = 0;

  // Team names
  String localName = '';
  String visitName = '';

  // Styles
  late TeamStyle localStyle;
  late TeamStyle visitStyle;

  // Timeouts (two circles)
  List<bool> localTimeouts = const [false, false];
  List<bool> visitTimeouts = const [false, false];

  bool get isInitialized => _initialized;

  /// Call once from the dashboard view.
  ///
  /// Kept as a `Future` to match the dashboards that call `await provider.initialize()`.
  Future<void> initialize() async {
    if (_initialized) return;

    localOnLeft = _prefs.readLocalOnLeft(defaultValue: true);
    localServe = _prefs.readLocalServe(defaultValue: true);

    localScore = _prefs.readScore(TeamSide.local);
    visitScore = _prefs.readScore(TeamSide.visit);
    localSets = _prefs.readSets(TeamSide.local);
    visitSets = _prefs.readSets(TeamSide.visit);

    localName = (_prefs.readTeamName(TeamSide.local) ?? _defaultLocalName)
        .toUpperCase();
    visitName = (_prefs.readTeamName(TeamSide.visit) ?? _defaultVisitName)
        .toUpperCase();

    localStyle = _prefs.readStyle(
      TeamSide.local,
      defaultStyle: _defaultLocalStyle,
    );
    visitStyle = _prefs.readStyle(
      TeamSide.visit,
      defaultStyle: _defaultVisitStyle,
    );

    localTimeouts = _prefs.readTimeouts(TeamSide.local);
    visitTimeouts = _prefs.readTimeouts(TeamSide.visit);

    _initialized = true;
    notifyListeners();
  }

  /// Backwards-compatible alias.
  /// Some older code used `init()`.
  @Deprecated('Use initialize()')
  void init() {
    // ignore: discarded_futures
    initialize();
  }

  // --------- Computed view values (left/right) ---------

  TeamSide get leftTeam => localOnLeft ? TeamSide.local : TeamSide.visit;
  TeamSide get rightTeam => localOnLeft ? TeamSide.visit : TeamSide.local;

  int get leftScore => leftTeam == TeamSide.local ? localScore : visitScore;
  int get rightScore => rightTeam == TeamSide.local ? localScore : visitScore;

  int get leftSets => leftTeam == TeamSide.local ? localSets : visitSets;
  int get rightSets => rightTeam == TeamSide.local ? localSets : visitSets;

  String get leftName => leftTeam == TeamSide.local ? localName : visitName;
  String get rightName => rightTeam == TeamSide.local ? localName : visitName;

  TeamStyle get leftStyle =>
      leftTeam == TeamSide.local ? localStyle : visitStyle;
  TeamStyle get rightStyle =>
      rightTeam == TeamSide.local ? localStyle : visitStyle;

  List<bool> get leftTimeouts =>
      leftTeam == TeamSide.local ? localTimeouts : visitTimeouts;
  List<bool> get rightTimeouts =>
      rightTeam == TeamSide.local ? localTimeouts : visitTimeouts;

  /// Whether the serve icon should be shown on the left half.
  bool get serveOnLeft => localOnLeft == localServe;

  /// Whether the serve icon should be shown on the right half.
  bool get serveOnRight => !serveOnLeft;

  // --------- Actions (team) ---------

  Future<void> setTeamName(TeamSide side, String value) async {
    final v = value.toUpperCase();
    if (side == TeamSide.local) {
      localName = v;
    } else {
      visitName = v;
    }
    await _prefs.writeTeamName(side, v);
    notifyListeners();
  }

  Future<void> setTeamStyle(TeamSide side, TeamStyle style) async {
    if (side == TeamSide.local) {
      localStyle = style;
    } else {
      visitStyle = style;
    }
    await _prefs.writeStyle(side, style);
    notifyListeners();
  }

  // --------- Actions (scores/sets) ---------

  Future<void> incrementScore(TeamSide side) async {
    if (side == TeamSide.local) {
      localScore = scoreRule.next(localScore);
      await _prefs.writeScore(TeamSide.local, localScore);
    } else {
      visitScore = scoreRule.next(visitScore);
      await _prefs.writeScore(TeamSide.visit, visitScore);
    }
    notifyListeners();
  }

  Future<void> decrementScore(TeamSide side) async {
    if (side == TeamSide.local) {
      localScore = scoreRule.previous(localScore);
      await _prefs.writeScore(TeamSide.local, localScore);
    } else {
      visitScore = scoreRule.previous(visitScore);
      await _prefs.writeScore(TeamSide.visit, visitScore);
    }
    notifyListeners();
  }

  Future<void> incrementSets(TeamSide side) async {
    if (side == TeamSide.local) {
      localSets = localSets + 1;
      await _prefs.writeSets(TeamSide.local, localSets);
    } else {
      visitSets = visitSets + 1;
      await _prefs.writeSets(TeamSide.visit, visitSets);
    }
    notifyListeners();
  }

  Future<void> decrementSets(TeamSide side) async {
    if (side == TeamSide.local) {
      localSets = localSets > 0 ? localSets - 1 : 0;
      await _prefs.writeSets(TeamSide.local, localSets);
    } else {
      visitSets = visitSets > 0 ? visitSets - 1 : 0;
      await _prefs.writeSets(TeamSide.visit, visitSets);
    }
    notifyListeners();
  }

  // Convenience for left/right actions
  Future<void> incrementLeftScore() => incrementScore(leftTeam);
  Future<void> decrementLeftScore() => decrementScore(leftTeam);
  Future<void> incrementRightScore() => incrementScore(rightTeam);
  Future<void> decrementRightScore() => decrementScore(rightTeam);

  Future<void> incrementLeftSets() => incrementSets(leftTeam);
  Future<void> decrementLeftSets() => decrementSets(leftTeam);
  Future<void> incrementRightSets() => incrementSets(rightTeam);
  Future<void> decrementRightSets() => decrementSets(rightTeam);

  // --------- Actions (serve / orientation) ---------

  Future<void> toggleServe() async {
    localServe = !localServe;
    await _prefs.writeLocalServe(localServe);
    notifyListeners();
  }

  Future<void> swapSides() async {
    localOnLeft = !localOnLeft;
    await _prefs.writeLocalOnLeft(localOnLeft);
    notifyListeners();
  }

  // --------- Actions (timeouts) ---------

  Future<void> toggleTimeout(TeamSide side, int index) async {
    if (index < 0 || index > 1) return;

    if (side == TeamSide.local) {
      final next = [...localTimeouts];
      next[index] = !next[index];
      localTimeouts = next;
      await _prefs.writeTimeouts(TeamSide.local, localTimeouts);
    } else {
      final next = [...visitTimeouts];
      next[index] = !next[index];
      visitTimeouts = next;
      await _prefs.writeTimeouts(TeamSide.visit, visitTimeouts);
    }
    notifyListeners();
  }

  Future<void> toggleLeftTimeout(int index) => toggleTimeout(leftTeam, index);
  Future<void> toggleRightTimeout(int index) => toggleTimeout(rightTeam, index);

  // --------- Reset ---------

  Future<void> resetMatch() async {
    localScore = 0;
    visitScore = 0;
    localServe = true;
    localTimeouts = const [false, false];
    visitTimeouts = const [false, false];

    await _prefs.writeScore(TeamSide.local, localScore);
    await _prefs.writeScore(TeamSide.visit, visitScore);
    await _prefs.writeLocalServe(localServe);
    await _prefs.writeTimeouts(TeamSide.local, localTimeouts);
    await _prefs.writeTimeouts(TeamSide.visit, visitTimeouts);

    notifyListeners();
  }

  Future<void> resetSets() async {
    localSets = 0;
    visitSets = 0;
    await _prefs.writeSets(TeamSide.local, localSets);
    await _prefs.writeSets(TeamSide.visit, visitSets);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await resetMatch();
    await resetSets();
  }
}
