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
  bool isShooting = false;

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
    this.directions = ['NorthEast', 'NorthWest', 'SouthEast', 'SouthWest', 'North', 'South', 'East', 'West'];
    this.directionsAndKeys = {
      'North': ['Up'],
      'South': ['Down'],
      'East': ['Right'],
      'West': ['Left'],
      'NorthEast': ['Up', 'Right'],
      'NorthWest': ['Up', 'Left'],
      'SouthEast': ['Down', 'Right'],
      'SouthWest': ['Down', 'Left']
    };
    xVelocity = 0;
    yVelocity = 0;
  }

  log(msg) => game.log(msg);
  CanvasRenderingContext2D get ctx() => game.ctx;
  List<ImageElement> get images() => game.images;

  shoot() {}

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
    // log('Direction: $direction');
    // log('x,y velocities: $xVelocity, $yVelocity');
    // log('location: $x, $y');
    move();
  }

  List<String> get keysForDirection() => directionsAndKeys[direction];

  updateDirectionAndVelocity(Set<String> keysPressed) {
    if (keysPressed.length == 0) return;

    log('keys pressed: ${keysPressed}');

    for (var dir in directions) {
      var keys = directionsAndKeys[dir];
      if (keys.every((key) => keysPressed.contains(key))) {
        this.direction = dir;
        if (keys.indexOf('Up') > -1) yVelocity = -1;
        if (keys.indexOf('Down') > -1) yVelocity = 1;
        if (keys.indexOf('Left') > -1) xVelocity = -1;
        if (keys.indexOf('Right') > -1) xVelocity = 1;
      }
    }
  }

  move() {
    x += xVelocity * speed;
    y += yVelocity * speed;
  }
}
