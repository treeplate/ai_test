import 'center.dart';
import 'evolution.dart';
import 'point.dart';

void main() {
  double bestFitness = double.infinity;
  while(bestFitness > 0) {
    List<Creature> creatures = List.generate(100, (index) => Creature());
    for(Creature creature in creatures) {
      creature.calcFitness([0, 0, 0, 10, 10, 0], findCenter([Point(0, 0), Point(0, 10), Point(10, 0)]));
      print("got $creature");
      if(creature.fitness! < bestFitness) bestFitness = creature.fitness!;
    }
    creatures.sort((Creature a, Creature b) => a.fitness!.compareTo(b.fitness!));
    List<Creature> babies = [];
    while(creatures.length > 1) {
      babies.add(creatures.first.crossover(creatures[1]));
      babies.add(creatures.first.crossover(creatures[1]));
      creatures.removeAt(0);
      creatures.removeAt(0);
    } 
  }
}