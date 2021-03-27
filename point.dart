class Point {
  const Point(this.x, this.y);
  final double x;
  final double y;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is Point
        && other.x == x
        && other.y == y;
  }

  @override
  int get hashCode {
    assert(false, 'This hashCode is terrible. If you are using it you should reimplement it.');
    return x.hashCode ^ y.hashCode;
  }

  @override
  String toString() => '($x, $y)';
}
