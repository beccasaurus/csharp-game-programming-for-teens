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
  Map<String, ImageElement> images;
  List<Sprite> sprites;
  Player player;
  Image background;
  Set<String> keysPressed;

  log(msg) => window.console.log(msg);

  Game() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    keysPressed = new Set<String>();
    sprites = new List<Sprite>();
    sprites.add(new Sprite(
      game: this, // we'll define an interface between Game/Canvas/Objects later once we know what we need!
      image: 'archer_attack.png',
      x: 50, y: 100,
      width: 96, height: 96,
      speed: 2,
      frameRows: {
        'North': 0,
        'NorthEast': 1,
        'East': 2,
        'SouthEast': 3,
        'South': 4,
        'SouthWest': 5,
        'NorthWest': 6,
        'West': 7
      },
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

  onKeyUp(event) {
    log("UP: ${event.keyIdentifier}");
    keysPressed.remove(event.keyIdentifier);
  }

  onKeyDown(event) {
    log("Pressed key: ${event.keyIdentifier}");

    if (event.keyIdentifier == 'U+001B') // ESC
      toggleLoop();
    else if (event.keyIdentifier == 'U+0020') // Spacebar
      togglePaused();
    else
      keysPressed.add(event.keyIdentifier);
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
      // log(time);
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
  int xVelocity;
  int yVelocity;
  Map<String, int> frameRows;
  int animationRate;
  String direction;
  List<String> directions;
  Map<String, List<String>> directionsAndKeys;
  int speed;

  Sprite([game, image, x, y, width, height, frameRows, animationRate, direction, speed]) {
    this.game = game;
    this.image = image;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.frameRows = frameRows;
    this.animationRate = animationRate;
    this.speed = speed;
    this.direction = (direction != null) ? direction : 'North';
    this.directions = ["NorthEast", "NorthWest", "SouthEast", "SouthWest", "North", "South", "East", "West"];
    this.directionsAndKeys = {
      'North': ["Up"],
      'South': ["Down"],
      'East': ["Right"],
      'West': ["Left"],
      'NorthEast': ["Up", "Right"],
      'NorthWest': ["Up", "Left"],
      'SouthEast': ["Down", "Right"],
      'SouthWest': ["Down", "Left"]
    };
    xVelocity = 0;
    yVelocity = 0;
  }

  log(msg) => game.log(msg);
  CanvasRenderingContext2D get ctx() => game.ctx;
  List<ImageElement> get images() => game.images;

  draw() {
    var img = images[image];
    ctx.drawImage(img,
      0, frameRows[direction] * height, width, height, // source      (x, y, width, height)
      x, y, width, height                              // destination (x, y, width, height)
    );
  }

  update() {
    xVelocity = 0;
    yVelocity = 0;
    var keysPressed = new Set<String>.from(game.keysPressed);
    updateDirectionAndVelocity(keysPressed);
    // log("Direction: $direction");
    // log("x,y velocities: $xVelocity, $yVelocity");
    // log("location: $x, $y");
    move();
  }

  List<String> get keysForDirection() => directionsAndKeys[direction];

  updateDirectionAndVelocity(Set<String> keysPressed) {
    if (keysPressed.length == 0) return;

    log("keys pressed: ${keysPressed}");

    for (var dir in directions) {
      var keys = directionsAndKeys[dir];
      if (keys.every((key) => keysPressed.contains(key))) {
        this.direction = dir;
        if (keys.indexOf("Up") > -1) yVelocity = -1;
        if (keys.indexOf("Down") > -1) yVelocity = 1;
        if (keys.indexOf("Left") > -1) xVelocity = -1;
        if (keys.indexOf("Right") > -1) xVelocity = 1;
      }
    }
  }

  move() {
    x += xVelocity * speed;
    y += yVelocity * speed;
  }
}

class Player extends Sprite {}
