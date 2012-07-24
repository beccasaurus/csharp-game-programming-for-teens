class ZombieSprite extends Sprite {
  ZombieSprite([x, y, game]) : super(
    x: x,
    y: y,
    game: game,
    image: 'zombie walk.png',
    width: 96,
    height: 96,
    speed: 1,
    frameColumns: 8,
    movesPerTick: 1,
    direction: Direction.east,
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
  ) {}

  move() {
    super.move();
    if (x == xMax)
      direction = Direction.west;
    else if (x == 0)
      direction = Direction.east;
  }
}
