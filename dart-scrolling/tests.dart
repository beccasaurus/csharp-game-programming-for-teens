#import('dart:html');
#import('vendor/unittest/unittest.dart');
#import('vendor/unittest/html_config.dart');
#import('scrolling.dart');

main() {
  useHtmlConfiguration();
  new TestSuite().run();
}

class TestSuite {
  CanvasScrolling scrolling;
  GameMap map;

  run() {
    setUp((){
      scrolling = new CanvasScrolling();
    });

    test('first thing', (){
      expect(scrolling, isNotNull);
      expect(scrolling.tilemap.length, equals(375));
    });

    test('can make a GameMap with a Viewport', (){
      var map = new GameMap(width: 1024, height: 768, viewport: new Viewport(x: 0, y: 0, width: 480, height: 320));
    });

    test('can scroll viewport', (){
      var map = new GameMap(width: 1024, height: 768, viewport: new Viewport(x: 0, y: 0, width: 480, height: 320));
      expect(map.viewport.coord, equals(new Coord(0, 0)));

      map.viewport.scrollTo(x: 100, y: 50);

      expect(map.viewport.coord, equals(new Coord(100, 50)));
    });

    test('GameMap has a tileMap', (){
      //
    });

    test('TileMap can give you information about the tile at any given point', (){
      // use case - get the info needed to render a tile
      var map = new GameMap(
        width: 40, height: 40,
        viewport: new Viewport(x: 0, y: 0, width: 4, height: 4),
        tileMap: new TileMap(image: 'palette.png', tileWidth: 5, tileHeight: 5, tileSpacing: 1, columns: 5, tiles: [
          1,  2,  3,  4,  5,  6,  7,  8,
          11, 12, 13, 14, 15, 16, 17, 18,
          21, 22, 23, 24, 25, 26, 27, 28,
          31, 32, 33, 34, 35, 36, 37, 38,
          41, 42, 43, 44, 45, 46, 47, 48,
          51, 52, 53, 54, 55, 56, 57, 58,
          61, 62, 63, 64, 65, 66, 67, 68,
          71, 72, 73, 74, 75, 76, 77, 78
        ])
      );

      // ^ make height/etc work ... remember, these are each 5x5px not 1x1 ... ... 8*5 x 8x5
      
      var info = map.tileMap.renderInfoFor(x: 7, y: 3) // 7 is 2px into the 2nd tile.  3 is 3px into the first.

      expect(info.tileId, equals(2));
      expect(info.tileX, equals(2)); // 2px X into this tile
      expect(info.tileY, equals(3)); // 3px Y into this tile
      expect(into.imageX, equals(8)); // px X is the coordinate to start from in the sheet ... --> [5px]1[5px]1
      expect(into.imageY, equals(3)); // px X is the coordinate to start from in the sheet
      expect(into.imageWidth, equals(5 - info.tileX)); // px X of width for the image to draw this
      expect(into.imageHeight, equals(5 - info.tileY)); // px Y of height for the image to draw this
    });
  }
}
