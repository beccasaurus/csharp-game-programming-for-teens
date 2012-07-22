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
  bool _animate = false;
  int _animationFrame = 0;
  int _lastTick = 0;
  int moves = 0;
  int movesPerTick = 0;
  Function onBoundsCollision;

  Sprite([game, image, x, y, width, height, frameColumns, frameRows, animationRate = 60, direction, speed, onBoundsCollision, movesPerTick]) {
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
    this._direction = (direction != null) ? direction : Direction.north;
    this.onBoundsCollision = onBoundsCollision;
    this.movesPerTick = movesPerTick;
  }

  Direction get direction() => _direction;
  void set direction(Direction dir) {
    if (dir != null) {
      moves = 1;
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
    if (onBoundsCollision != null && ((x < 0) || (y < 0) || (x + width > game.width) || (y + height > game.height)))
      onBoundsCollision(this);

    if (movesPerTick != null) moves += movesPerTick;
    if (_animate) animate(tick);
    if (moves > 0) move();
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
    while (moves > 0) {
      moves--;
      x += direction.xVelocity * speed;
      y += direction.yVelocity * speed;
    }
  }
}
