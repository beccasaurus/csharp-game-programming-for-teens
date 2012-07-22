class Sprite {
  Game game;
  String image;
  int x;
  int y;
  int width;
  int height;
  List<Direction> frameRows;
  int frameColumns;
  int animationRate;
  Direction _direction;
  int speed;
  bool _move = false;
  bool _animate = false;
  int _animationFrame = 0;
  int _lastTick = 0;

  Sprite([game, image, x, y, width, height, frameColumns, frameRows, animationRate = 60, direction, speed]) {
    this.game = game;
    this.image = image;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.frameColumns = frameColumns;
    this.frameRows = frameRows;
    this.animationRate = animationRate;
    this.speed = speed;
    this.direction = (direction != null) ? direction : Direction.north;
  }

  Direction get direction() => _direction;
  void set direction(Direction dir) {
    if (dir != null) {
      _move = true; // we did something, we need to move
      _direction = dir;
    }
  }

  log(msg) => game.log(msg);
  CanvasRenderingContext2D get ctx() => game.ctx;
  List<ImageElement> get images() => game.images;

  draw(tick) {
    var img = images[image];
    ctx.drawImage(img,
      _animationFrame * width, frameRows.indexOf(direction) * height, width, height, // source (x, y, width, height)
      x, y, width, height // destination (x, y, width, height)
    );
  }

  update(tick) {
    if (_animate) animate(tick);
    if (_move) move();
  }

  animateOnce() {
    _animate = true;
  }

  animate(tick) {
    if (tick > _lastTick + animationRate) {
      _lastTick = tick;
      _animationFrame++;
      if (_animationFrame >= frameColumns) { // done with this animation
        _lastTick = 0;
        _animationFrame = 0;
        _animate = false;
      }
    }
  }

  move() {
    game.log("move");
    _move = false;
    x += direction.xVelocity * speed;
    y += direction.yVelocity * speed;
  }
}
