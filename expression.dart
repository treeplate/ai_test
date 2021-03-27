import 'dart:collection';
import 'dart:math' as math;

import 'point.dart';

const int _opAdd = -0x0010;
const int _opSubtract = -0x0020;
const int _opMultiply = -0x0040;
const int _opDivide = -0x0080;
const int _opModulus = -0x0100;
const int _opRound = -0x0200;
const int _opMin = -0x0400;
const int _opMax = -0x0800;
const int _opInput = -0x1000;

class _ProgramGenerator {
  _ProgramGenerator(this.random);

  final math.Random random;

  Queue<double> _queue = Queue<double>();

  double getNext() {
    if (_queue.isNotEmpty)
      return _queue.removeFirst();
    switch (random.nextInt(30)) { // about one third of output should be opcodes
      case 0: return _opAdd.toDouble();
      case 1: return _opSubtract.toDouble();
      case 2: return _opMultiply.toDouble();
      case 3: return _opDivide.toDouble();
      //case 4: return _opModulus.toDouble();
      //case 5: return _opRound.toDouble();
      //case 6: return _opMin.toDouble();
      //case 7: return _opMax.toDouble();
      case 8: _queue.add(_opInput.toDouble()); return random.nextDouble() * 10.0;
      default: return random.nextDouble();
    }
  }

  void reset() {
    _queue.clear();
  }
}

class Expression {
  const Expression.blank() : _program = const <double>[];

  const Expression.fromRawDoubles(this._program);

  factory Expression.random(math.Random random, int maxLength) {
    _ProgramGenerator generator = _ProgramGenerator(random);
    return Expression.fromRawDoubles(List<double>.generate(
      random.nextInt(maxLength),
      (int index) => generator.getNext(),
    ));
  }

  static const double _kStopEarlyProbability = 0.01;
  static const double _kContinueAnywayProbability = 0.1;
  static const double _kSwitchModeProbability = 0.02;

  static Expression recombine(math.Random random, Expression a, Expression b) {
    final List<double> child = <double>[];
    int indexA = 0;
    int indexB = 0;
    int mode = random.nextInt(2); // take from a or b by default
    _ProgramGenerator generator = _ProgramGenerator(random);
    while ((indexA < a._program.length || indexB < b._program.length || random.nextDouble() < _kContinueAnywayProbability) && (random.nextDouble() > _kStopEarlyProbability)) {
      if (random.nextDouble() < _kSwitchModeProbability) {
        mode = random.nextInt(6);
        generator.reset();
      }
      switch (mode) {
        case 0: // take from a
          if (indexA < a._program.length)
            child.add(a._program[indexA]);
          indexA += 1;
          indexB += 1;
          break;
        case 1: // take from b
          if (indexB < b._program.length)
            child.add(b._program[indexB]);
          indexA += 1;
          indexB += 1;
          break;
        case 2: // splice in from a
          if (indexA < a._program.length)
            child.add(a._program[indexA]);
          indexA += 1;
          break;
        case 3: // splice in from b
          if (indexB < b._program.length)
            child.add(b._program[indexB]);
          indexB += 1;
          break;
        case 4: // insert random
          child.add(generator.getNext());
          break;
        case 5: // skip
          indexA += 1;
          indexB += 1;
          break;
        default:
          throw UnimplementedError();
      }
    }
    return Expression.fromRawDoubles(child);
  }

  final List<double> _program;

  Point evaluate(List<double> inputs) {
    final _Stack<double> stack = _Stack<double>(0.0);
    for (double opcode in _program) {
      if (opcode.isNegative) {
        switch (opcode.round()) {
          case _opAdd: stack.push(stack.pop() + stack.pop()); break;
          case _opSubtract: stack.push(stack.pop() - stack.pop()); break;
          case _opMultiply: stack.push(stack.pop() * stack.pop()); break;
          case _opDivide: stack.push(stack.pop() / stack.pop()); break;
          case _opModulus: stack.push(stack.pop() % stack.pop()); break;
          case _opRound: stack.push(stack.pop().roundToDouble()); break;
          case _opMin: stack.push(math.min(stack.pop(), stack.pop())); break;
          case _opMax: stack.push(math.max(stack.pop(), stack.pop())); break;
          case _opInput:
            final double value = stack.pop();
            if (value.isFinite) {
              final int index = value.round();
              if (index >= 0 && index < inputs.length) {
                stack.push(inputs[index]);
              } else {
                stack.push(double.nan);
              }
            } else {
              stack.push(double.nan);
            }
            break;
        }
      } else {
        stack.push(opcode);
      }
    }
    return Point(stack.pop(), stack.pop());
  }

  List<double> toRawDoubles() => _program.toList();

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    other as Expression;
    if (other._program.length != _program.length)
      return false;
    for (int index = 0; index < _program.length; index += 1) {
      if (_program[index] != other._program[index])
        return false;
    }
    return true;
  }

  @override
  int get hashCode {
    assert(false, 'This hashCode is terrible. If you are using it you should reimplement it.');
    int result = _program.length.hashCode;
    for (int index = 0; index < _program.length; index += 1) {
      result ^= (_program[index].hashCode ^ index.hashCode);
    }
    return result;
  }

  @override
  String toString() {
    final _Stack<String> stack = _Stack<String>('0.0');
    for (double opcode in _program) {
      if (opcode.isNegative) {
        switch (opcode.round()) {
          case _opAdd: stack.push('(${stack.pop()} + ${stack.pop()})'); break;
          case _opSubtract: stack.push('(${stack.pop()} - ${stack.pop()})'); break;
          case _opMultiply: stack.push('(${stack.pop()} * ${stack.pop()})'); break;
          case _opDivide: stack.push('(${stack.pop()} / ${stack.pop()})'); break;
          case _opModulus: stack.push('(${stack.pop()} % ${stack.pop()})'); break;
          case _opRound: stack.push('round(${stack.pop()})'); break;
          case _opMin: stack.push('min(${stack.pop()}, ${stack.pop()})'); break;
          case _opMax: stack.push('max(${stack.pop()}, ${stack.pop()})'); break;
          case _opInput: stack.push('input[${stack.pop()}]'); break;
          default: stack.push('${stack.pop()} /* ignored: $opcode */'); break;
        }
      } else {
        stack.push('$opcode');
      }
    }
    final String value1 = stack.pop();
    final String value2 = stack.pop();
    stack.push(value2);
    stack.push(value1);
    return stack.toString();
  }
}

class _Stack<T> {
  _Stack(this._default);

  final T _default;

  final List<T> _values = <T>[];

  void push(T value) => _values.add(value);

  T pop() {
    if (_values.isEmpty)
      return _default;
    return _values.removeLast();
  }

  @override
  String toString() => _values.join(', ');
}
