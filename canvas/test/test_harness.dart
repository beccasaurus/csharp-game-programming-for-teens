#import('dart:html');
#import('../vendor/unittest/unittest.dart');
#import('../vendor/unittest/html_config.dart');
#import('../lib/game.dart');

#source('direction_test.dart');
#source('sprite_test.dart');

main() {
  useHtmlConfiguration();
  DirectionTest.run();
  SpriteTest.run();
}
