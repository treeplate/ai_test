import 'dart:io';
import 'dart:math';

import 'expression.dart';
import 'point.dart';

class Creature {
  Expression data;

  Creature() : data = Expression.blank();

  Creature.make(this.data);
  factory Creature.loadExp(String filename) {
    return Creature.make(Expression.fromRawDoubles(
      File(filename)
          .readAsStringSync()
          .split(',')
          .map((e) => double.parse(e))
          .toList(),
    ));
  }

  double? fitness;

  void calcFitness(List<double> inputs, Point goalOutput) {
    Point evaluated = data.evaluate(inputs);
    fitness = sqrt(pow(goalOutput.x - evaluated.x, 2) +
        pow(goalOutput.y - evaluated.y, 2));
    ;
  }

  Creature crossover(Creature other) {
    // TODO: crossover
    return Creature.make(Expression.blank());
  }

  void saveExp(String filename) {
    File(filename).writeAsStringSync(data.toRawDoubles().join(','));
  }

  String toString() => data.toString() + "($fitness)";
}
