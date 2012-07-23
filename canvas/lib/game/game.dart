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
    sprites = new List<Sprite>();

    // TODO - move this out of here!  make subclasses for now, eg. ArrowSprite?  This would make it very 
    //        easy to re-use certain sprites AND it may help us come up with the final Sprite class design 
    //        as we'll end up with a few well-factored classes instead of 1 that tries to handle all edge cases!
    //        Sprite subclasses should probably override a few key methods, eg. update() and draw().
    //        Sprite may end up becoming an interface without a base implementation.  We'll see.

    // Arrow
    var arrow = new Sprite(
      game: this, // we'll define an interface between Game/Canvas/Objects later once we know what we need!
      image: 'arrow.png',
      alive: false,
      x: 0, y: 0,
      width: 32, height: 32,
      speed: 5,
      frameColumns: 1,
      movesPerTick: 1,
      projectile: true
    );
    sprites.add(arrow);

    // Zombie
    sprites.add(new Sprite(
      game: this, // we'll define an interface between Game/Canvas/Objects later once we know what we need!
      image: 'zombie walk.png',
      x: 5, y: 5,
      width: 96, height: 96,
      speed: 1,
      frameColumns: 8,
      movesPerTick: 1,
      frameRows: [
        Direction.north,
        Direction.northEast,
        Direction.east,
        Direction.southEast,
        Direction.south,
        Direction.southWest,
        Direction.west,
        Direction.northWest
      ],
      direction: Direction.east,
      onBoundsCollision: (s) {
        s.direction = (s.direction == Direction.east) ? Direction.west : Direction.east;
      }
    ));

    player = new Player(sprite: new Sprite(
      game: this, // we'll define an interface between Game/Canvas/Objects later once we know what we need!
      image: 'archer_attack.png',
      x: 50, y: 100,
      width: 96, height: 96,
      speed: 2,
      frameColumns: 10,
      frameRows: [
        Direction.north,
        Direction.northEast,
        Direction.east,
        Direction.southEast,
        Direction.south,
        Direction.southWest,
        Direction.west,
        Direction.northWest
      ]
    ));
    player.arrow = arrow;

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
