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
  bool stopped = false;
  Random random;
  Map<String, ImageElement> images;
  List<Sprite> sprites;
  Player player;
  Image background;

  Game() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    random = new Random();
    sprites = new List<Sprite>();
    load();
  }

  load() {
    ctx.fillText("Loading ...", 10, 10);
    images = new Map<String, ImageElement>();
    for (var image in ["grass.bmp", "archer_attack.png"]) {
      window.console.log("loading $image ...");
      images[image] = new ImageElement(src: "assets/$image");
      images[image].on.load.add((event) {
        window.console.log("loaded $image");
      });
    }
  }

  get doneLoading() {
    if (_doneLoading) return true;    
    _doneLoading = images.getValues().every((img) => img.complete);
    return _doneLoading;
  }

  start() => window.requestAnimationFrame(loop);

  loop(int time) {
    window.console.log(time);
    if (doneLoading) {
      update();
      draw();
    }
    window.requestAnimationFrame(loop);
  }

  update() {}

  draw() {
    drawBackground();
    ctx.fillText("DONE", 50, 50);
  }

  drawBackground() {
    // ctx.drawImage(image, 0, 0, 50, 50, 0, 0, 50, 50);
  }
}

class Sprite {

}

class Player extends Sprite {}
