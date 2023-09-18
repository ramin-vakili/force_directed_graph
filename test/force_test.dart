import 'package:flutter_test/flutter_test.dart';

void main() {
  test('direction toward center', () {
    const Offset node1 = Offset(10, 10);
    const Offset node2 = Offset(340, 340);
    const Offset center = Offset(300, 300);

    final centerForce1 = (center - node1) * 0.1;
    final centerForce2 = (center - node2) * 0.1;

    final node1NewPos = node1 + centerForce1;
    final node2NewPos = node2 + centerForce2;

    print('node1 from $node1 moves $centerForce1 and ends up at $node1NewPos');
    print('node2 from $node2 moves $centerForce2 and ends up at $node2NewPos');
  });
}
