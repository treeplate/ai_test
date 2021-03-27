import '../expression.dart';
import '../point.dart';

void main() {
  assert(const Expression.blank().evaluate([]) == Point(0.0, 0.0));
  assert(const Expression.blank().toString() == '0.0, 0.0');
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0]).evaluate([]) == Point(2.0, 1.0));
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0]).toString() == '1.0, 2.0');
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0, -0x0010]).evaluate([]) == Point(3.0, 0.0));
  assert(const Expression.fromRawDoubles(<double>[1.0, 2.0, -0x0010]).toString() == '0.0, (2.0 + 1.0)');
  print('PASS');
}
