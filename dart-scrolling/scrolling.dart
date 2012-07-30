#import('dart:html');
#import('dart:math');

main() => new CanvasScrolling().start();

class CanvasScrolling {
  CanvasRenderingContext2D _ctx;
  CanvasElement _canvas;
  Point _scrollPosition;
  Set<String> _pressedKeys;
  num _scrollVelocity = 2;
  int _mapWidth = 800;
  int _mapHeight = 500;
  int _tileSize = 32;
  int _tileSpacing = 1;
  Map<String, Element> _infoElements;
  DivElement _map;
  ImageElement _palette;
  int _paletteColumns = 5;
  bool _running;

  List<int> tilemap = const [17, 2, 17, 2, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 8, 113, 113, 113, 113, 126, 123, 137, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 136, 123, 123, 123, 134, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 136, 127, 123, 119, 134, 113, 91, 113, 113, 113, 113, 113, 102, 100, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 113, 128, 123, 125, 113, 113, 113, 113, 113, 113, 113, 92, 139, 80, 113, 113, 113, 96, 94, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 102, 122, 100, 113, 113, 113, 96, 94, 113, 113, 7, 113, 113, 135, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 92, 110, 139, 80, 113, 113, 113, 96, 94, 113, 113, 7, 113, 113, 113, 113, 113, 113, 130, 113, 113, 113, 113, 113, 113, 113, 81, 81, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 135, 113, 113, 113, 113, 113, 113, 138, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 126, 40, 134, 113, 113, 113, 113, 113, 113, 130, 113, 113, 106, 104, 113, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 128, 125, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 84, 84, 104, 113, 113, 7, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 86, 115, 113, 113, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7];

  CanvasScrolling() {
    _map = document.query('#map');
    _canvas = document.query('#canvas');
    _ctx = _canvas.getContext('2d');
    _scrollPosition = new Point(0, _mapHeight - _canvas.height);
    _pressedKeys = new Set<String>();
    _palette = new ImageElement(src: 'palette.png');
    _palette.on.load.add((e) => _info('loading', 'Loaded palette.png'));
    document.on.keyDown.add((event) => _pressedKeys.add(event.keyIdentifier));
    document.on.keyUp.add((event) => _pressedKeys.remove(event.keyIdentifier));

    var tileNum = 1;
    for (var y = 0; y < _mapHeight; y += 32) {
      for (var x = 0; x < _mapWidth; x += 32) {
        var html = '<div class="cell" style="position: absolute; top: ${y}px; left: ${x}px; width: 32px; height: 32px;">$tileNum</div>';
        _map.nodes.add(new Element.html(html));
        tileNum++;
      }
    }
  }

  start() {
    _running = true;
    window.requestAnimationFrame(_loop);
  }

  stop() => _running = false;

  _loop(int tick) {
    if (_running) {
      _update(tick);
      _draw(tick);
      window.requestAnimationFrame(_loop);
    }
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
    if (_scrollPosition.x >= _mapWidth - _canvas.width) _scrollPosition.x = _mapWidth - _canvas.width;
    if (_scrollPosition.y >= _mapHeight - _canvas.height) _scrollPosition.y = _mapHeight - _canvas.height;
  }

  _info(id, value) {
    if (_infoElements == null) _infoElements = new Map<String, Element>();
    if (! _infoElements.containsKey(id)) _infoElements[id] = document.query('#${id}');
    _infoElements[id].innerHTML = value;
  }

  _draw(int tick) {
    // clear ... only need b/c we're not drawing the full box (yet)
    _ctx.clearRect(0, 0, _canvas.width, _canvas.height);

    // move canvas within full map
    _canvas.style.left = '${_scrollPosition.x}px';
    _canvas.style.top = '${_scrollPosition.y}px';

    // update UI
    _info('scrollPosition', 'x: ${_scrollPosition.x}, y: ${_scrollPosition.y}');
    
    // find starting tiles
    int mapTilesAcross = (_mapWidth / _tileSize).toInt();
    int mapTilesDown = (_mapHeight / _tileSize).toInt();
    int firstTileIndex = (_scrollPosition.y / _tileSize).toInt() * mapTilesAcross + (_scrollPosition.x / _tileSize).toInt();
    int partialYpx = _tileSize - (_scrollPosition.y % _tileSize).toInt();
    int partialXpx = _tileSize - (_scrollPosition.x % _tileSize).toInt();
    int row = 0;

    _info('startingTile', 'First Index: $firstTileIndex');

    // render all
    for (int y = 0; y < _canvas.height;) {
      int tileHeight = (y == 0) ? partialYpx : _tileSize;
      int tileIndex = (mapTilesAcross * row) + firstTileIndex;
      if (tileIndex >= tilemap.length) break; // shouldn't need this! XXX

      for (int x = 0; x < _canvas.width;) {
        if (tileIndex >= tilemap.length) break; // shouldn't need this! XXX
        int tileWidth = (x == 0) ? partialXpx : _tileSize;
        num tileId = tilemap[tileIndex];
        num paletteX = ((tileId - 1) % _paletteColumns) * (_tileSize + _tileSpacing);
        num paletteY = (((tileId - 1) / _paletteColumns).toInt() * (_tileSize + _tileSpacing));
        if (tileHeight != _tileSize) paletteY += _tileSize - partialYpx;
        if (tileWidth != _tileSize) paletteX += _tileSize - partialXpx;

        _info('rendering', '($paletteX,$paletteY) ${tileWidth}x${tileHeight} ---> ($x,$y) ${tileWidth}x${tileHeight}');
        _ctx.drawImage(
          _palette,
          paletteX, paletteY, tileWidth, tileHeight,
          x, y, tileWidth, tileHeight
        );

        tileIndex++;
        x += tileWidth;
      }

      y += tileHeight;
      row++;
    }
  }
}
