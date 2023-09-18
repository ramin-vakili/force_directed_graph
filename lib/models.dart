import 'dart:ui';

/// A node of the graph.
class Node {
  /// The current position of the node in the graph canvas.
  Offset position;

  /// The direction of the force which makes the node to move.
  late Offset force;

  /// Size.
  final double size;

  /// Initializes a node of the graph.
  Node({required this.position, this.size = 5}) {
    force = const Offset(0, 0);
  }

  void updatePosition() {
    position += force;
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
