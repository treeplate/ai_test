class Creature {
  dynamic data; //TODO: add type

  Creature.make(this.data);

  double? fitness;

  Creature minF(Creature other) {
    if((other..calcFitness()).fitness! >= (this..calcFitness()).fitness!) {
      return other;
    }
    return this;
  }

  void calcFitness() {
    // TODO: fitness
  }

  Creature crossover(Creature other) {
    // TODO: crossover
    return Creature.make(null);
  }

  void mutate() {
    // TODO: mutate
  } 

  String toString() => data.toString() + "($fitness)"; //
}