import 'dart:math';
import 'dart:html';

class Dot {
  final CanvasElement canvasElement;
  final CanvasRenderingContext2D canvasContext;

  double x;
  double y;
  double z;
  double radius;
  double xProjected;
  double yProjected;
  double scaleProjected;
  double perspective;
  double projection_center_x;
  double projection_center_y;

  Dot(
    this.canvasElement,
    this.canvasContext,
    this.perspective,
    this.projection_center_x,
    this.projection_center_y,
  ) {
    var random = Random();
    x = (random.nextDouble() - .5) * canvasElement.width;
    y = (random.nextDouble() - .5) * canvasElement.height;
    z = random.nextDouble() * canvasElement.width;
    radius = 10;

    xProjected = 0;
    yProjected = 0;
    scaleProjected = 0;
  }

  /// Project the dot element from the 3d perspective to the 2d pesrpective
  void projectDot() {
    scaleProjected = perspective / (perspective + z);
    xProjected = (x * scaleProjected) + projection_center_x;
    yProjected = (y * scaleProjected) + projection_center_y;
  }

  void draw() {
    projectDot();
    canvasContext.globalAlpha = (1 - z / canvasElement.width).abs();
    canvasContext.fillRect(
      xProjected - radius,
      yProjected - radius,
      radius * 2 * scaleProjected,
      radius * 2 * scaleProjected,
    );
  }
}
