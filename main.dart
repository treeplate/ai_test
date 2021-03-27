import 'dart:convert';
import 'dart:io';

import 'center.dart';

final RegExp inputPattern = RegExp(r'^\(([0-9]+.[0-9]+), ([0-9]+.[0-9]+)\)$');

void main() async {
  try {
    List<Point> points = <Point>[];
    await for (String line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
      Match? inputParts = inputPattern.matchAsPrefix(line);
      if (inputParts == null || inputParts.groupCount != 2)
        throw FormatException('Invalid input data: "$line"');
      double x = double.parse(inputParts.group(1)!);
      double y = double.parse(inputParts.group(2)!);
      points.add(Point(x, y));
      if (points.length == 3) {
        final Point center = findCenter(points);
        print('${center.x}\n${center.y}');
        points.clear();
      }
    }
    if (points.isNotEmpty)
      throw FormatException('Input did not contain a set of complete triangles.');
  } on FormatException catch (error) {
    stderr.write(error.toString());
  }
}
