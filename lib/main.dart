import 'dart:math';

import 'package:flutter/material.dart';
import 'package:force_directed_graph/helpers.dart';

import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Size? _graphCanvasSize;
  final GlobalKey _canvasKey = GlobalKey();

  final List<Node> _nodes = <Node>[];
  final List<Edge> _edges = <Edge>[];

  @override
  void initState() {
    super.initState();

    _resetGraph();
    _setupTicker();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _resetGraph();
  }

  void _setupTicker() {
    createTicker((elapsed) {
      if (_graphCanvasSize != null) {
        _calculateForces(_graphCanvasSize!);
      }
      setState(() {});
    }).start();
  }

  void _resetGraph() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _canvasKey.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        _graphCanvasSize = renderBox.size;
        _createRandomGraph(_graphCanvasSize!);
        setState(() {});
      }
    });
  }

  void _calculateForces(Size size) {
    // Create force to attract nodes toward center.
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect canvasRect = Rect.fromLTRB(0, 0, size.width, size.height);

    for (Node node in _nodes) {
      final Offset forceTowardCenter = (center - node.position) * 0.1;
      node.force = forceTowardCenter;
    }

    // Create force between each pair of nodes
    for (int i = 0; i < _nodes.length; i++) {
      for (int j = i + 1; j < _nodes.length; j++) {
        final Node node1 = _nodes[i];
        final Node node2 = _nodes[j];
        final direction = node2.position - node1.position;

        final Offset forceBetweenTwoNodes =
            direction / direction.distanceSquared * 200;

        node1.force -= forceBetweenTwoNodes;
        node2.force += forceBetweenTwoNodes;

        node1.updatePosition();

        if (!canvasRect.contains(node1.position)) {
          node1.position = Offset(node1.position.dx.clamp(0, size.width),
              node1.position.dy.clamp(0, size.height));
        }
      }
    }

    // Calculate attractive force of edges.
    for (final Edge edge in _edges) {
      final Node node1 = edge.node1;
      final Node node2 = edge.node2;

      final distance = node2.position - node1.position;

      final attractiveForce = distance * 0.8;
      node1.force += attractiveForce;
      node2.force -= attractiveForce;
      node1.updatePosition();
      node2.updatePosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          key: _canvasKey,
          child: _graphCanvasSize != null
              ? CustomPaint(
                  foregroundPainter: GraphPainter(
                  nodes: _nodes,
                  edges: _edges,
                ))
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _createRandomGraph(Size canvasSize) {
    final List<Node> nodes = generateRandomNodes(canvasSize, numberOfNodes: 30);
    _nodes.addAll(nodes);

    // Add edges
    for (int i = 0; i < 20; i++) {
      final (int, int) randomPairs = _getRandomEdgePairs();
      _edges.add(Edge(
        _nodes[randomPairs.$1],
        _nodes[randomPairs.$2],
        Random().nextInt(20).toDouble(),
      ));
    }
  }

  (int, int) _getRandomEdgePairs() {
    int i = 0, j = 0;
    do {
      final Random random = Random();
      i = random.nextInt(_nodes.length);
      j = random.nextInt(_nodes.length);
    } while (i == j);

    return (i, j);
  }
}

class GraphPainter extends CustomPainter {
  GraphPainter({required this.nodes, required this.edges})
      : _nodePaint = Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 2;

  final List<Node> nodes;
  final List<Edge> edges;

  final Paint _nodePaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Node node in nodes) {
      canvas.drawCircle(node.position, node.size, _nodePaint);
    }

    for (final Edge edge in edges) {
      canvas.drawLine(edge.node1.position, edge.node2.position, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
