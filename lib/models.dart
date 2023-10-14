import 'dart:ui';
import 'package:flutter/material.dart';

/// A node of the graph.
class Node {
  Node(this.mass, {Offset? initialPosition})
      : position = initialPosition ?? Offset.zero;

  Offset position;

  final double mass;

  void updatePosition({required Offset force, required Size size}) {
    position += force / mass;
  }
}

/// The edge in the graph which connects two nodes.
class Edge {
  final Node node1;
  final Node node2;

  /// The length of this edge.
  final double distance;

  Edge(this.node1, this.node2, this.distance);
}
