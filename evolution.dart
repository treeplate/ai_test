import 'dart:io';
import 'dart:math';

import 'center.dart';
import 'expression.dart';
import 'point.dart';

final Random r = Random();

class Creature {
  Expression data;

  Creature() : data = Expression.random(r, 20);

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

  late double fitness;

  void calcFitness() {
    fitness = 0;
    List<List<Point>> triangles = [];
    for (int i = 0; i < 20; i++) {
      triangles.add([
        Point(r.nextDouble()*1000, r.nextDouble()*1000),
        Point(r.nextDouble()*1000, r.nextDouble()*1000),
        Point(r.nextDouble()*1000, r.nextDouble()*1000)
      ]);
    }
    for (List<Point> triangle in triangles) {
      List<double> inputs = [triangle[0].x, triangle[0].y, triangle[1].x, triangle[1].y, triangle[2].x, triangle[2].y];
      Point goalOutput = findCenter(triangle);
      Point evaluated = data.evaluate(inputs);
      double dx = goalOutput.x - evaluated.x;
      double dy = goalOutput.y - evaluated.y;
      fitness = max(fitness, dx * dx + dy * dy + data.countOutputs());
    }
  }

  Creature crossover(Creature other) {
    return Creature.make(Expression.recombine(r, data, other.data));
  }

  void saveExp(String filename) {
    File(filename).writeAsStringSync(data.toRawDoubles().join(','));
  }

  String toString() => "$fitness:$data";
}
