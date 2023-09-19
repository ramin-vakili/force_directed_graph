import 'package:flutter/material.dart';

import 'models.dart';

class GraphPainter extends CustomPainter {
  GraphPainter({required this.nodes, required this.edges})
      : _nodePaint = Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 2,
        _edgePaint = Paint()
          ..color = Colors.deepOrange
          ..strokeWidth = 3;

  final List<Node> nodes;
  final List<Edge> edges;

  final Paint _nodePaint;
  final Paint _edgePaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Edge edge in edges) {
      canvas.drawLine(edge.node1.position, edge.node2.position, _edgePaint);
    }

    for (final Node node in nodes) {
      canvas.drawCircle(node.position, node.size, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
