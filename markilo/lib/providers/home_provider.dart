import 'package:flutter/material.dart';
import 'package:markilo/domain/scoreboard/score_rule.dart';
import 'package:markilo/domain/scoreboard/sport.dart';
import 'package:markilo/domain/scoreboard/team_style.dart';
import 'package:markilo/providers/scoreboard/base_scoreboard_provider.dart';

/// Provider for the Voley dashboard.
class HomeProvider extends BaseScoreboardProvider {
  HomeProvider()
      : super(
          sport: Sport.voley,
          scoreRule: StepScoreRule(step: 1, min: 0),
          defaultLocalName: '<LOCAL>',
          defaultVisitName: '<VISITANTE>',
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
