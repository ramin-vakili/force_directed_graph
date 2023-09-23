import 'package:flutter/material.dart';
import 'package:force_directed_graph/helpers.dart';

import 'graph_painter.dart';
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
  Node? _selectedNode;

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
      final Offset forceTowardCenter = (center - node.position) * 0.07;
      node.updatePosition(force: forceTowardCenter, size: _graphCanvasSize!);
    }

    // Create force between each pair of nodes
    for (int i = 0; i < _nodes.length; i++) {
      for (int j = i + 1; j < _nodes.length; j++) {
        final Node node1 = _nodes[i];
        final Node node2 = _nodes[j];
        final direction = node2.position - node1.position;

        final Offset forceBetweenTwoNodes =
            direction / direction.distanceSquared * 700;

        node1.updatePosition(
          force: -forceBetweenTwoNodes,
          size: _graphCanvasSize!,
        );
        node2.updatePosition(
          force: forceBetweenTwoNodes,
          size: _graphCanvasSize!,
        );

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

      final attractiveForce = distance * 1.1;

      node1.updatePosition(force: attractiveForce, size: _graphCanvasSize!);
      node2.updatePosition(force: -attractiveForce, size: _graphCanvasSize!);
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
              ? GestureDetector(
                  onPanStart: (details) {
                    final Offset mousePos = Offset(
                      details.localPosition.dx,
                      details.localPosition.dy,
                    );

                    for (final Node node in _nodes) {
                      final Rect nodeRect = Rect.fromCenter(
                        center: node.position,
                        width: node.mass,
                        height: node.mass,
                      );

                      if (nodeRect.contains(mousePos)) {
                        _selectedNode = node;
                        break;
                      }
                    }
                  },
                  onPanUpdate: (details) {
                    if (_selectedNode == null) {
                      return;
                    }
                    final Offset mousePos = Offset(
                        details.localPosition.dx, details.localPosition.dy);

                    _selectedNode!.position = Offset.lerp(
                      _selectedNode!.position,
                      mousePos,
                      0.2,
                    )!;
                  },
                  onPanEnd: (details) {
                    _selectedNode = null;
                  },
                  child: CustomPaint(
                    painter: GraphPainter(
                      nodes: _nodes,
                      edges: _edges,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _createRandomGraph(Size canvasSize) {
    _nodes.addAll(generateRandomNodes(canvasSize, numberOfNodes: 30));
    _edges.addAll(generateRandomEdgesForNodes(_nodes));
  }
}
