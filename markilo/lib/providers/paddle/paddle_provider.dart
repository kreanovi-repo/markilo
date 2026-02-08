import 'package:flutter/material.dart';
import 'package:markilo/domain/scoreboard/score_rule.dart';
import 'package:markilo/domain/scoreboard/sport.dart';
import 'package:markilo/domain/scoreboard/team_style.dart';
import 'package:markilo/providers/scoreboard/base_scoreboard_provider.dart';

/// Provider for the Paddle dashboard.
class PaddleProvider extends BaseScoreboardProvider {
  PaddleProvider()
      : super(
          sport: Sport.paddle,
          scoreRule: SequenceScoreRule(const [0, 15, 30, 40, 50]),
          defaultLocalName: '<IZQUIERDA>',
          defaultVisitName: '<DERECHA>',
          defaultLocalStyle: const TeamStyle(
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
          defaultVisitStyle: const TeamStyle(
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
        );
}
