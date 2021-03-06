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
  int animationX;
  int animationY;
  int width;
  int height;
  List<Direction> frameRows;
  int frameColumns;
  int animationRate;
  Direction _direction;
  int speed;
  bool projectile;
  bool _animate = false;
  Function _afterAnimate;
  int _animationFrame = 0;
  int _lastTick = 0;
  int moves = 0;
  int movesPerTick = 0;
  bool alive = true;

  Sprite([game, image, x, y, width, height, frameColumns, frameRows, animationRate = 60, direction, speed, movesPerTick, alive = true, projectile = false, animate = false]) {
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
    this.movesPerTick = movesPerTick;
    this.alive = alive;
    this.projectile = projectile;
    this._animate = animate;
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
    ctx.drawImage(img,
      animationX, animationY, width, height, // source (x, y, width, height)
      x, y, width, height                    // destination (x, y, width, height)
    );
  }

  update(tick) {
    if (! alive) return;

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
    calculateAnimationFrame();
    if (moves > 0) move();
  }

  onDamage(projectile) {
    game.log("onDamage!");
    this.alive = false;
  }

  // This is wicked icky ... will redo/kill this later.
  animateOnce([Function callback]) {
    game.log("got callback $callback");
    _animate = true;
    _afterAnimate = () {
      if (callback != null) callback();
      _animate = false;
    };
  }

  animate(tick) {
    if (tick > _lastTick + animationRate) {
      _lastTick = tick;
      _animationFrame++;
      if (_animationFrame >= frameColumns) { // done with this animation
        _lastTick = 0;
        _animationFrame = 0;
        if (_afterAnimate != null) _afterAnimate();
      }
    }
  }

  calculateAnimationFrame() {
      animationX = _animationFrame * width;
      animationY = (frameRows == null) ? 0 : frameRows.indexOf(direction) * height;
  }

  int get xMax() => game.width - width;
  int get yMax() => game.height - height;

  move() {
    while (moves > 0) {
      moves--;
      x += direction.xVelocity * speed;
      y += direction.yVelocity * speed;

      // Make sure x/y doesn't leave the board.
      if (x > xMax) x = xMax;
      if (x < 0) x = 0;
      if (y > yMax) y = yMax;
      if (y < 0) y = 0;
    }
  }

  bool collidesWith(Sprite other) => Sprite.areColliding(this, other);
}
