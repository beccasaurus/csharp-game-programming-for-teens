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

  run() {
    setUp((){
      scrolling = new CanvasScrolling();
    });

    test('first thing', (){
      expect(scrolling, isNotNull);
      expect(scrolling.tilemap.length, equals(375));
    });
  }
}
