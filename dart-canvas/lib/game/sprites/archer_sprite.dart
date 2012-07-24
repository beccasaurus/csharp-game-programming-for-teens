class ArcherSprite extends Sprite {
  ArcherSprite([x, y, game]) : super(
    x: x,
    y: y,
    game: game,
    image: 'archer_attack.png',
    width: 96,
    height: 96,
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
  ) {}
}
