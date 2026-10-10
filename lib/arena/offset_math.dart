import 'dart:ui';

extension OffsetMath on Offset {
  double dot(Offset other) => dx * other.dx + dy * other.dy;

  Offset reflect(Offset normal) => this - normal * (2 * dot(normal));
}
