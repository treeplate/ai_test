import 'dart:math' as math;

import 'point.dart';

class Expression {
  const Expression.blank() : _program = const <double>[];
  const Expression.fromRawDoubles(this._program);

  final List<double> _program;

  static const int _opAdd = -0x0010;
  static const int _opSubtract = -0x0020;
  static const int _opMultiply = -0x0040;
  static const int _opDivide = -0x0080;
  static const int _opModulus = -0x0100;
  static const int _opRound = -0x0200;
  static const int _opMin = -0x0400;
  static const int _opMax = -0x0800;
  static const int _opInput = -0x1000;
  
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
