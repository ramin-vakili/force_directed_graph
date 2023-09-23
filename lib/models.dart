import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class WorldObject implements RigidBody {
  @override
  Offset position;

  @override
  final double mass;

  WorldObject(this.mass, {Offset? initialPosition})
      : position = initialPosition ?? Offset.zero;

  @override
  void updatePosition({required Offset force, required Size size}) {
    position += force / mass;
  }
}

/// A node of the graph.
class Node extends WorldObject {
  Node(super.mass, {super.initialPosition});
}

/// The edge in the graph which connects two nodes.
class Edge {
  final Node node1;
  final Node node2;

  /// The length of this edge.
  final double distance;

  Edge(this.node1, this.node2, this.distance);
}

/// A Goo ball.
class GooBall extends WorldObject {
  GooBall(super.mass, {super.initialPosition});
}

/// A building consists of goo balls stick together in a graph shape structure.
///
/// *-----*
///  \   / \
///   \ /   \
///    *-----*
class GooStructure extends WorldObject {
  GooStructure(super.mass, {super.initialPosition});
}

class GooSimulation {
  final GroundGravitySimulation gravitySimulation;

  GooSimulation(this.gravitySimulation);
}

abstract class RigidBody {
  double get mass;

  Offset get position;

  /// The force and the size of the 2D world to update position based on
  /// the [force].
  void updatePosition({required Offset force, required Size size});
}

/// A simulation environment to simulate the force between Goo balls.
class GooBallsInteractionSimulation {
  final GooStructure gooStructure;

  GooBallsInteractionSimulation(this.gooStructure);
}

/// A simulation for gravity which app.
class GroundGravitySimulation {
  static const gravityConstant = 0.5;

  /// The size of the 2D world.
  final Size size;

  /// Initializes Ground Gravity Simulation object.
  GroundGravitySimulation({required this.objects, required this.size});

  /// Objects that will get.
  final List<RigidBody> objects;

  void updateForces() {
    for (RigidBody object in objects) {
      final Offset groundTarget = Offset(object.position.dx, size.height);
      final Offset forceTowardTheGround =
          (groundTarget - object.position) * gravityConstant;

      object.updatePosition(force: forceTowardTheGround, size: size);
    }
  }
}
