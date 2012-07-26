#import('dart:html');
#import('dart:math');

main() => new MultiTouchTest().run();

class MultiTouchTest {

  static final PI_2 = Math.PI * 2;

  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  bool _stopped;
  List<Point> _touchedPoints;
  List<List<Point>> _recentPoints;
  bool _mouseDown;

  MultiTouchTest() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext('2d');
    _touchedPoints = new List<Point>();
    _recentPoints = new List<List<Point>>();
    _setupEvents();
    document.body.nodes.add(new Element.html("<h1>Screen ${window.screen.width}x${window.screen.height}</h1>"));
  }

  run() {
    _stopped = false;
    window.requestAnimationFrame(_loop);
  }

  draw(tick) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.fillText(tick.toString(), 10, canvas.height - 10);

    for (var point in _touchedPoints) {
      drawPoint(point);
      ctx.fillText("(${point.x}, ${point.y})", 0, 10);
    }

    ctx.globalAlpha = 0.8;
    for (var points in _recentPoints) {
      for (var point in points)
        drawPoint(point);
      if (ctx.globalAlpha > 0.2)
        ctx.globalAlpha -= 0.2;
    }
    ctx.globalAlpha = 1.0;

    if (_recentPoints.length > 5) _recentPoints.removeRange(0, 1);
    _recentPoints.add(_touchedPoints);
    _touchedPoints = new List<Point>();
  }

  drawPoint(point) {
    ctx.beginPath();
    ctx.arc(point.x, point.y, 2, 0, PI_2, false);
    ctx.fill();
    ctx.closePath();
  }

  _loop(int tick) {
    if (!_stopped) {
      draw(tick);
      window.requestAnimationFrame(_loop);
    }
  }

  _setupEvents() {
    canvas.on.click.add((e) => _touchedPoints.add(new Point(e.offsetX, e.offsetY)));
    canvas.on.mouseDown.add((e) => _mouseDown = true);
    canvas.on.mouseUp.add((e) => _mouseDown = false);
    canvas.on.mouseMove.add((e) {
      if (_mouseDown)
        _touchedPoints.add(new Point(e.offsetX, e.offsetY));
    });
    canvas.on.touchStart.add((e) {
      _mouseDown = true;
    }, false);
    canvas.on.touchEnd.add((e) {
      _mouseDown = false;
    });
    canvas.on.touchMove.add((e) {
      _touchedPoints.addAdd(e.touches.map((touch) => new Point(touch.pageX, touch.pageY)));
    });
  }
}
