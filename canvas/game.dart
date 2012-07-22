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
    log('UP: ${event.keyIdentifier}');
    keysPressed.remove(event.keyIdentifier);
  }

  onKeyDown(event) {
    log('Pressed key: ${event.keyIdentifier}');

    if (event.keyIdentifier == 'U+001B') // ESC
      toggleLoop();
    else if (event.keyIdentifier == 'U+0020') // Spacebar
      togglePaused();
    else if (event.keyIdentifier == 'Enter')
      sprites[0].shoot();
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
