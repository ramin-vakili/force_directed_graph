import 'dart:math';
import 'dart:ui';

import 'models.dart';

/// Generates some random on random positions inside the [size] area.
List<Vertex> generateRandomNodes(Size size, {int numberOfNodes = 10}) {
  final List<Vertex> vertices = <Vertex>[];

  for (int i = 0; i < numberOfNodes; i++) {
    vertices.add(Vertex(
      pos: _getRandomPositionInCanvas(size),
      size: _getRandomNodeSize(),
    ));
  }

  return vertices;
}

Offset _getRandomPositionInCanvas(Size size) => Offset(
      Random().nextInt(size.width.toInt()).toDouble(),
      Random().nextInt(size.height.toInt()).toDouble(),
    );

double _getRandomNodeSize() => Random().nextInt(5) + 4.0;
