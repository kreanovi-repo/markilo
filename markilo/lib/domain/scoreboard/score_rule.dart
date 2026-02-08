/// Defines how a score changes when you "increment" / "decrement".
///
/// Examples:
/// - Voley: +1 / -1
/// - Paddle: 0 → 15 → 30 → 40 → 50 (and backwards)
abstract class ScoreRule {
  int next(int current);
  int previous(int current);
}

class StepScoreRule implements ScoreRule {
  StepScoreRule({this.step = 1, this.min = 0});

  final int step;
  final int min;

  @override
  int next(int current) => current + step;

  @override
  int previous(int current) {
    final v = current - step;
    return v < min ? min : v;
  }
}

class SequenceScoreRule implements ScoreRule {
  SequenceScoreRule(this.sequence) : assert(sequence.isNotEmpty);

  final List<int> sequence;

  @override
  int next(int current) {
    // Find first value strictly greater than current.
    for (final v in sequence) {
      if (v > current) return v;
    }
    return sequence.last;
  }

  @override
  int previous(int current) {
    // Find last value strictly smaller than current.
    for (int i = sequence.length - 1; i >= 0; i--) {
      final v = sequence[i];
      if (v < current) return v;
    }
    return sequence.first;
  }
}
