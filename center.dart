import 'point.dart';

Point findCenter(List<Point> triangle) {
  //TODO: evolve
  assert(triangle.length == 3);
  return Point(
    (triangle[0].x + triangle[1].x + triangle[2].x) / 3.0,
    (triangle[0].y + triangle[1].y + triangle[2].y) / 3.0,
  );
}
