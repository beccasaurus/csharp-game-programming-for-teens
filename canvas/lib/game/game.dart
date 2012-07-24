// TODO major refactoring
//
// TODO feature: player should die/lose if zombie touches them
// TODO killing 1 zombie should make 2 spawn, then 3, and so on.
// TODO for now, zombies could bounce around at angles, like jezzballs ... diagonals ... when hitting East bounds, could randomly select any West bound direction.

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
  List<String> imagesToLoad = const ['grass.bmp', 'archer_attack.png', 'zombie walk.png', 'arrow.png'];

  log(msg) => window.console.log(msg);

  Game() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    keysPressed = new Set<String>();

    player = new Player(sprite: new ArcherSprite(x: 50, y: 100, game: this));
    player.arrow = new ArrowSprite(game: this);

    sprites = new List<Sprite>();
    sprites.add(player.arrow);
    sprites.add(new ZombieSprite(x: 5, y: 5, game: this));

    load();
  }

  load() {
    ctx.fillText('Loading ...', 10, 10);
    images = new Map<String, ImageElement>();
    for (var image in imagesToLoad) {
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
    else if (event.keyIdentifier == 'U+0050') // P
      togglePaused();
    else if (event.keyIdentifier == 'U+0020') // Spacebar
      player.shoot();
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

  loop(int tick) {
    if (runLoop) {
      if (doneLoading) {
        if (! paused) update(tick);
        draw(tick);
      }
      window.requestAnimationFrame(loop);
    }
  }

  update(int tick) {
    for (var sprite in sprites)
      sprite.update(tick);
    player.update(tick);
  }

  draw(int tick) {
    clearCanvas();
    drawBackground();
    for (var sprite in sprites)
      sprite.draw(tick);
    player.draw(tick);
  }

  clearCanvas() => ctx.clearRect(0, 0, width, height);

  drawBackground() {
    ctx.drawImage(images['grass.bmp'], 0, 0, width, height);
  }
}
