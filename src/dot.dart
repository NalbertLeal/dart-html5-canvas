import 'dart:js';
import 'dart:math';
import 'dart:html';

enum AxisIncDec {
  INCREASING,
  DECREASING,
  NONE,
}

class Dot {
  final CanvasElement canvasElement;
  final CanvasRenderingContext2D canvasContext;

  double x = 0;
  // AxisIncDec isXIncreasing = AxisIncDec.NONE;
  double y = 0;
  double z = 0;
  // AxisIncDec isZIncreasing = AxisIncDec.NONE;
  double theta;
  AxisIncDec thetaStatus = AxisIncDec.NONE;
  double phi;
  double radius = 10;
  double globeRadius;
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
    this.globeRadius,
  ) {
    var random = Random();
    theta = random.nextDouble() * 2 * pi; // [0, 2pi]
    phi = acos((random.nextDouble() * 2) - 1); // [0, pi]

    xProjected = 0;
    yProjected = 0;
    scaleProjected = 0;
  }

  /// Project the dot element from the 3d perspective to the 2d pesrpective
  void projectDot() {
    x = globeRadius * sin(phi) * cos(theta);
    y = globeRadius * cos(phi);
    z = globeRadius * sin(phi) * sin(theta) + globeRadius;

    thetaStatus = thetaStatus == AxisIncDec.NONE && theta >= pi
        ? AxisIncDec.DECREASING
        : AxisIncDec.INCREASING;

    scaleProjected = perspective / (perspective + z);
    xProjected = (x * scaleProjected) + projection_center_x;
    yProjected = (y * scaleProjected) + projection_center_y;
  }

  void draw(num frame) {
    animateTheta(frame);
    projectDot();
    canvasContext.globalAlpha = (1 - z / canvasElement.width).abs();

    canvasContext.beginPath();
    canvasContext.arc(
        xProjected, yProjected, radius * scaleProjected, 0, pi * 2);
    canvasContext.fill();
  }

  void animateTheta(num frame) {
    if (thetaStatus == AxisIncDec.INCREASING) {
      theta += 1;
    } else if (thetaStatus == AxisIncDec.DECREASING) {
      theta -= 1;
    }

    if (theta >= 2*pi && thetaStatus == AxisIncDec.INCREASING) {
      thetaStatus = AxisIncDec.DECREASING;
    }
    if (theta <= 0 && thetaStatus == AxisIncDec.DECREASING) {
      thetaStatus = AxisIncDec.INCREASING;
    }
  }
}
