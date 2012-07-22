class Sprite {

  // http://stackoverflow.com/questions/2440377/javascript-collision-detection
  // also like: http://www.owenpellegrin.com/articles/vb-net/simple-collision-detection/  <--- we're not doing the box-in-box check (i don't think)
  static bool areColliding(Sprite a, Sprite b) {
    return !(
        ((a.y + a.height) < (b.y)) ||
        (a.y > (b.y + b.height)) ||
        ((a.x + a.width) < b.x) ||
        (a.x > (b.x + b.width))
    );
  }

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
  bool projectile;
  bool _animate = false;
  Function _afterAnimate = false;
  int _animationFrame = 0;
  int _lastTick = 0;
  int moves = 0;
  int movesPerTick = 0;
  bool alive = true;
  Function onBoundsCollision;

  Sprite([game, image, x, y, width, height, frameColumns, frameRows, animationRate = 60, direction, speed, onBoundsCollision, movesPerTick, alive = true, projectile = false]) {
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
    this.alive = alive;
    this.projectile = projectile;
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
    if (! alive) return;

    var img = images[image];
    var sourceY = (frameRows == null) ? 0 : frameRows.indexOf(direction) * height;
    ctx.drawImage(img,
      _animationFrame * width, sourceY, width, height, // source (x, y, width, height)
      x, y, width, height // destination (x, y, width, height)
    );
  }

  update(tick) {
    if (! alive) return;

    if (onBoundsCollision != null && ((x < 0) || (y < 0) || (x + width > game.width) || (y + height > game.height)))
      onBoundsCollision(this);

    if (projectile) {
      game.sprites.forEach((sprite) {
        if (sprite != this && sprite != game.player) {
          if (collidesWith(sprite)) {
            log("projectile ${this.image} collides with other sprite: ${sprite.image}, arrow: $x $y and other: ${sprite.x} ${sprite.y}");
            log(sprite);
            log(this);
            sprite.onDamage(this);
            this.alive = false; // arrow can only hit 1 enemy
            return;
          }
        }
      });
    }

    if (movesPerTick != null) moves += movesPerTick;
    if (_animate) animate(tick);
    if (moves > 0) move();
  }

  onDamage(projectile) {
    game.log("onDamage!");
    this.alive = false;
  }

  animateOnce([Function callback]) {
    game.log("got callback $callback");
    _animate = true;
    _afterAnimate = callback;
  }

  animate(tick) {
    if (tick > _lastTick + animationRate) {
      _lastTick = tick;
      _animationFrame++;
      if (_animationFrame >= frameColumns) { // done with this animation
        _lastTick = 0;
        _animationFrame = 0;
        _animate = false;
        if (_afterAnimate != null) _afterAnimate();
      }
    }
  }

  move() {
    while (moves > 0) {
      moves--;
      x += direction.xVelocity * speed;
      y += direction.yVelocity * speed;
    }
  }

  bool collidesWith(Sprite other) => Sprite.areColliding(this, other);
}
