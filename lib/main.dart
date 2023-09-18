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

class _MyHomePageState extends State<MyHomePage> {
  Size? _graphCanvasSize;
  final GlobalKey _canvasKey = GlobalKey();

  final List<Node> _nodes = <Node>[];

  @override
  void initState() {
    super.initState();

    _resetGraph();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _resetGraph();
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

  @override
  Widget build(BuildContext context) {
    print('Nodes ${_nodes.length}');
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
    for (final Node node in nodes) {
      canvas.drawCircle(node.pos, node.size, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
