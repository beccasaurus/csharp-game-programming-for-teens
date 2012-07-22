#import('dart:html');
#import('dart:math');

main() => new Game().start();

class Game {
  Document doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  int width;
  int height;
  bool _doneLoading = false;
  bool runLoop = true;
  bool paused = false;
  bool stopped = false;
  Random random;
  Map<String, ImageElement> images;
  List<Sprite> sprites;
  Player player;
  Image background;

  Game() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    random = new Random();
    sprites = new List<Sprite>();
    load();
  }

  load() {
    ctx.fillText('Loading ...', 10, 10);
    images = new Map<String, ImageElement>();
    for (var image in ['grass.bmp', 'archer_attack.png']) {
      window.console.log('loading $image ...');
      images[image] = new ImageElement(src: 'assets/$image');
      images[image].on.load.add((event) {
        window.console.log('loaded $image');
      });
    }
  }

  get doneLoading() {
    if (_doneLoading)
      return true;
    else {
      _doneLoading = images.getValues().every((img) => img.complete);
      if (_doneLoading)
        onLoaded();
      return _doneLoading;
    }
  }

  onLoaded() {
    document.on.keyUp.add((event) => onKeyUp(event));
    document.on.keyDown.add((event) => onKeyDown(event));
  }

  onKeyUp(event) {} 

  onKeyDown(event) {
    window.console.log(event.keyIdentifier);
    if (event.keyIdentifier == 'U+001B') // ESC
      toggleLoop();
    if (event.keyIdentifier == 'U+0020') // Spacebar
      togglePaused();
  }

  toggleLoop() {
    if (runLoop) stop();
    else start();
  }

  togglePaused() {
    paused = !paused;
    document.query('#paused').dataAttributes['enabled'] = true;
  }

  start() {
    runLoop = true;
    document.query('#stopped').dataAttributes['enabled'] = false;
    window.requestAnimationFrame(loop);
  }

  stop() {
    runLoop = false;
    document.query('#stopped').dataAttributes['enabled'] = true;
  }

  loop(int time) {
    if (runLoop) {
      window.console.log(time);
      if (doneLoading) {
        if (! paused) update();
        draw();
      }
      window.requestAnimationFrame(loop);
    }
  }

  update() {}

  draw() {
    clearCanvas();
    drawBackground();
    ctx.fillText('DONE', 50, 50);
  }

  clearCanvas() => ctx.clearRect(0, 0, width, height);

  drawBackground() {
    // ctx.drawImage(image, 0, 0, 50, 50, 0, 0, 50, 50);
  }
}

class Sprite {

}

class Player extends Sprite {}
