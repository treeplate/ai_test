import 'evolution.dart';

void main() {
  double bestFitness = double.infinity;
  List<Creature> creatures = List.generate(100, (index) => Creature());
  for (Creature creature in creatures) {
    creature.calcFitness();
  }
  creatures.sort((Creature a, Creature b) => a.fitness!.compareTo(b.fitness!));
  int gens = 0;
  while (bestFitness > 0) {
    if (creatures[0].fitness! < bestFitness) {
      bestFitness = creatures[0].fitness!;
      print("$gens:${creatures[0]}\n");
    }
    List<Creature> babies = [];
    while (babies.length < 100) {
      babies.add(creatures.first.crossover(creatures[1]));
    }
    creatures = creatures + babies;
    for (Creature creature in babies) {
      creature.calcFitness();
    }
    creatures
        .sort((Creature a, Creature b) => a.fitness!.compareTo(b.fitness!));
    creatures.length = 100;
    gens++;
  }
}
