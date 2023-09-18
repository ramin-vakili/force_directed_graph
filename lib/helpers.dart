import 'dart:math';
import 'dart:ui';

import 'models.dart';

/// Generates some random on random positions inside the [size] area.
List<Node> generateRandomNodes(Size size, {int numberOfNodes = 10}) {
  print('Size: (${size.width}, ${size.height})');
  final List<Node> nodes = <Node>[];

  for (int i = 0; i < numberOfNodes; i++) {
    nodes.add(Node(
      pos: _getRandomPositionInCanvas(size),
      size: _getRandomNodeSize(),
    ));
  }

  return nodes;
}

Offset _getRandomPositionInCanvas(Size size) => Offset(
      Random().nextInt(size.width.toInt()).toDouble(),
      Random().nextInt(size.height.toInt()).toDouble(),
    );

double _getRandomNodeSize() => Random().nextInt(5) + 4.0;
