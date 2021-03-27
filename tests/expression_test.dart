import 'dart:math' as math;

import '../expression.dart';
import '../point.dart';

void main() {
  assert(const Expression.blank().evaluate([]) == Point(0.0, 0.0));
  assert(const Expression.blank().toString() == '0.0, 0.0');
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0]).evaluate([]) == Point(2.0, 1.0));
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0]).toString() == '1.0, 2.0');
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0, -0x0010]).evaluate([]) == Point(3.0, 0.0));
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0, -0x0010]).toString() == '0.0, (2.0 + 1.0)');

  final Expression expression = Expression.random(math.Random(0), 20);
  assert(expression.toString() == 'round(max(0.9425361662697325, (0.7803419679858374 * (0.7139906593763793 - min(0.8863148172405516, 0.0))))), (0.16500915917398906 % min(0.8500456606354337, input[6.245064326868958]))');
  assert(expression.evaluate([double.nan, double.nan, double.nan, double.nan, double.nan, double.nan, -0.1]) == Point(0.06500915917398906, 1.0));

  assert(Expression.recombine(
    math.Random(0),
    const Expression.fromRawDoubles(<double>[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]),
    const Expression.fromRawDoubles(<double>[10.0, 20.0, 30.0, 40.0, 50.0, 60.0]),
  ) == Expression.fromRawDoubles(<double>[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 0.23254717202072794, 1.0, 6.0]));

  print('PASS');
}
