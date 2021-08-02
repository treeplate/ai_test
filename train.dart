import 'evolution.dart';

void main() {
  double bestFitness = double.infinity;
  List<Creature> creatures = List.generate(100, (index) => Creature());
  for (Creature creature in creatures) {
    creature.calcFitness();
  }
  creatures.sort((Creature a, Creature b) => a.fitness.compareTo(b.fitness));
  int gens = 0;
  while (bestFitness > (creatures[0].data.countOutputs())) {
    if (creatures[0].fitness < bestFitness) {
      bestFitness = creatures[0].fitness;
      print("$gens:${creatures[0]}\n");
    }
    List<Creature> babies = [];
    while (babies.length < 500) {
      babies.add(creatures[r.nextInt(creatures.length)].crossover(creatures[r.nextInt(creatures.length)]));
    }
    creatures = creatures + babies;
    for (Creature creature in babies) {
      creature.calcFitness();
    }
    creatures
        .sort((Creature a, Creature b) => a.fitness.compareTo(b.fitness));
    creatures.length = 2;
    gens++;
  }
  print("Success! ($gens:${creatures[0]})");
}
