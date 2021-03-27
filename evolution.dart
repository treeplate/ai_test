import 'expression.dart';

class Creature {
  Expression data;

  Creature(): data = Expression.blank();

  Creature.make(this.data);

  double? fitness;

  void calcFitness() {
    // TODO: fitness
  }

  Creature crossover(Creature other) {
    // TODO: crossover
    return Creature.make(Expression.blank());
  }

  void mutate() {
    // TODO: mutate
  } 

  String toString() => data.toString() + "($fitness)"; //
}
