import 'dart:ui';

/// A node of the graph.
class Vertex {
  /// The current position of the node in the graph canvas.
  Offset pos;

  /// The direction of the force which makes the node to move.
  late Offset force;

  /// Size.
  final double size;

  /// Initializes a node of the graph.
  Vertex({required this.pos, this.size = 5}) {
    force = const Offset(0, 0);
  }
}

/// The edge in the graph which connects two nodes.
class Edge {
  final Vertex vertex1;
  final Vertex vertex2;

  /// The length of this edge.
  final double distance;

  Edge(this.vertex1, this.vertex2, this.distance);
}
