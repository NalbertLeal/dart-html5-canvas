import 'dart:js';
import 'dart:html';

import './dot.dart';

class ParticlesSphere {
  final String canvasHtmlId;
  final List<Dot> dots = [];

  CanvasElement canvasElement;
  CanvasRenderingContext2D canvasContext;

  double perspective;
  double projection_center_x;
  double projection_center_y;

  ParticlesSphere(this.canvasHtmlId) {
    canvasElement = document.getElementById('scene');
    canvasContext = canvasElement.getContext('2d');

    window.addEventListener('resize', (_) => onResize());
    onResize();

    // The varialbles used to transform the perspective from 3d to 2d
    perspective = canvasElement.width * 0.8;
    projection_center_x = canvasElement.width / 2;
    projection_center_y = canvasElement.height / 2;

    // create 800 dots
    for (var i=0; i < 800; i++) {
      dots.add(
        Dot(
          canvasElement,
          canvasContext,
          perspective,
          projection_center_x,
          projection_center_y,
          canvasElement.width/3,
        ),
      );
    }

    // Start to render the result
    render(0);
  }

  void onResize() {
    final width = canvasElement.offsetWidth;
    final height = canvasElement.offsetHeight;

    if (window.devicePixelRatio > 1) {
      canvasElement.height = canvasElement.clientHeight * 2;
      canvasElement.width = canvasElement.clientWidth * 2;
    } else {
      canvasElement.width = width;
      canvasElement.height = height;
    }
  }

  void render(num frame) {
    canvasContext.clearRect(
      0,
      0,
      canvasElement.width,
      canvasElement.height,
    );

    for(var i=0; i < 800; i++) {
      dots[i].draw(frame);
    }

    window.requestAnimationFrame(render);
  }
}
