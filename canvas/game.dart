#import('dart:html');
#import('dart:math');

main() => new Game().start();

// TODO after we have sprites animating, split up this file.  then consider extracting class(es) from Game.
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

  log(msg) => window.console.log(msg);

  Game() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    random = new Random();
    sprites = new List<Sprite>();
    sprites.add(new Sprite(
      game: this, // we'll define an interface between Game/Canvas/Objects later once we know what we need!
      image: 'archer_attack.png',
      x: 50, y: 100,
      width: 96, height: 96,
      frameRows: { 'North': 0, 'South': 4, 'East': 2, 'West': 7 },
      animationRate: 20
    ));
    load();
  }

  load() {
    ctx.fillText('Loading ...', 10, 10);
    images = new Map<String, ImageElement>();
    for (var image in ['grass.bmp', 'archer_attack.png']) {
      log('loading $image ...');
      images[image] = new ImageElement(src: 'assets/$image');
      images[image].on.load.add((event) {
        log('loaded $image');
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
    log('Loading Complete.');
  }

  onKeyUp(event) {} 

  onKeyDown(event) {
    log(event.keyIdentifier);
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
    document.query('#paused').dataAttributes['enabled'] = paused;
  }

  start() {
    runLoop = true;
    document.query('#stopped').dataAttributes['enabled'] = ! runLoop;
    window.requestAnimationFrame(loop);
  }

  stop() {
    runLoop = false;
    document.query('#stopped').dataAttributes['enabled'] = true;
  }

  loop(int time) {
    if (runLoop) {
      log(time);
      if (doneLoading) {
        if (! paused) update();
        draw();
      }
      window.requestAnimationFrame(loop);
    }
  }

  update() {
    for (var sprite in sprites)
      sprite.update();
  }

  draw() {
    clearCanvas();
    drawBackground();
    for (var sprite in sprites)
      sprite.draw();
  }

  clearCanvas() => ctx.clearRect(0, 0, width, height);

  drawBackground() {
    ctx.drawImage(images['grass.bmp'], 0, 0, width, height);
  }
}

class Sprite {
  Game game;
  String image;
  int x;
  int y;
  int width;
  int height;
  Map<String, int> frameRows;
  int animationRate;
  String direction;
  List<String> directions;

  Sprite([var game, var image, var x, var y, var width, var height, var frameRows, var animationRate, var direction]) {
    this.game = game;
    this.image = image;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.frameRows = frameRows;
    this.animationRate = animationRate;
    this.direction = (direction != null) ? direction : 'North';
    this.directions = ['North', 'South', 'East', 'West'];
    random = new Random();
  }

  CanvasRenderingContext2D get ctx() => game.ctx;
  List<ImageElement> get images() => game.images;

  draw() {
    var img = images[image];
    ctx.drawImage(img,
      // source      (x, y, width, height)
      0, frameRows[direction] * height, width, height,
      // destination (x, y, width, height)
      x, y, width, height
    );
  }

  Random random;
  update() {
    if (random.nextInt(6) % 2 == 0)
      x += random.nextInt(5);
    else
      x -= random.nextInt(5);

    if (random.nextInt(6) % 2 == 0)
      y += random.nextInt(5);
    else
      y -= random.nextInt(5);

    direction = directions[random.nextInt(directions.length - 1)];

    // log('x,y  $x $y');
  }
}

class Player extends Sprite {}
