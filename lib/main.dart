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
        _calculateForces(
          Offset(_graphCanvasSize!.width / 2, _graphCanvasSize!.height / 2),
        );
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

  void _calculateForces(Offset center) {
    // Create force to attract nodes toward center.
    for (Node node in _nodes) {
      final Offset forceTowardCenter = (center - node.position) * 0.1;
      node.force = forceTowardCenter;

      node.updatePosition();
    }

    // Create force between each pair of nodes
    for (int i = 0; i < _nodes.length; i++) {
      for (int j = i + 1; j < _nodes.length; j++) {
        final Node node1 = _nodes[i];
        final Node node2 = _nodes[j];
        final direction = node2.position - node1.position;

        final Offset forceBetweenTwoNodes =
            direction / direction.distanceSquared * 1000;


        node1.force -= forceBetweenTwoNodes;
        node2.force += forceBetweenTwoNodes;

        node1.updatePosition();
      }
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
              ? CustomPaint(foregroundPainter: GraphPainter(_nodes))
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _createRandomGraph(Size canvasSize) {
    final List<Node> nodes = generateRandomNodes(canvasSize);
    _nodes.addAll(nodes);
  }
}

class GraphPainter extends CustomPainter {
  GraphPainter(this.nodes) : _nodePaint = Paint()..color = Colors.blueAccent;

  final List<Node> nodes;

  final Paint _nodePaint;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawCircle(nodes.first.position, nodes.first.size, _nodePaint);
    for (final Node node in nodes) {
      canvas.drawCircle(node.position, node.size, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
