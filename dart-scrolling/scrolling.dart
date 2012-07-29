#import('dart:html');
#import('dart:math');

main() => new CanvasScrolling().run();

class CanvasScrolling {
  CanvasRenderingContext2D _ctx;
  CanvasElement _canvas;
  Point _scrollPosition;
  Set<String> _pressedKeys;
  num _scrollVelocity = 1;
  int _mapWidth = 800;
  int _mapHeight = 500;

  List<int> tiles = const [17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 8, 113, 113, 113, 113, 126, 123, 137, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 136, 123, 123, 123, 134, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 136, 127, 123, 119, 134, 113, 91, 113, 113, 113, 113, 113, 102, 100, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 113, 128, 123, 125, 113, 113, 113, 113, 113, 113, 113, 92, 139, 80, 113, 113, 113, 96, 94, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 102, 122, 100, 113, 113, 113, 96, 94, 113, 113, 7, 113, 113, 135, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 92, 110, 139, 80, 113, 113, 113, 96, 94, 113, 113, 7, 113, 113, 113, 113, 113, 113, 130, 113, 113, 113, 113, 113, 113, 113, 81, 81, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 135, 113, 113, 113, 113, 113, 113, 138, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 126, 40, 134, 113, 113, 113, 113, 113, 113, 130, 113, 113, 106, 104, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 128, 125, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 84, 84, 104, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 86, 115, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7];

  CanvasScrolling() {
    _canvas = document.query('#canvas');
    _ctx = _canvas.getContext('2d');
    _scrollPosition = new Point(10, 10);
    _pressedKeys = new Set<String>();
    document.on.keyDown.add((event) => _pressedKeys.add(event.keyIdentifier));
    document.on.keyUp.add((event) => _pressedKeys.remove(event.keyIdentifier));
  }

  run() => window.requestAnimationFrame(_loop);

  _loop(int tick) {
    _update(tick);
    _draw(tick);
    window.requestAnimationFrame(_loop);
  }
  
  _update(int tick) {
    _updateScrollPosition();
  }

  _updateScrollPosition() {
    if (_pressedKeys.contains(KeyName.UP))    _scrollPosition.y -= _scrollVelocity;
    if (_pressedKeys.contains(KeyName.DOWN))  _scrollPosition.y += _scrollVelocity;
    if (_pressedKeys.contains(KeyName.LEFT))  _scrollPosition.x -= _scrollVelocity;
    if (_pressedKeys.contains(KeyName.RIGHT)) _scrollPosition.x += _scrollVelocity;

    if (_scrollPosition.x < 0) _scrollPosition.x = 0;
    if (_scrollPosition.y < 0) _scrollPosition.y = 0;
    if (_scrollPosition.x > _mapWidth - _canvas.width) _scrollPosition.x = _mapWidth - _canvas.width;
    if (_scrollPosition.y > _mapHeight - _canvas.height) _scrollPosition.y = _mapHeight - _canvas.height;
  }

  _draw(int tick) {
    // move canvas within full map
    _canvas.style.left = '${_scrollPosition.x}px';
    _canvas.style.top = '${_scrollPosition.y}px';

    // update UI
    document.query('#scrollPosition').innerHTML = 'x: ${_scrollPosition.x}, y: ${_scrollPosition.y}';
  }
}
