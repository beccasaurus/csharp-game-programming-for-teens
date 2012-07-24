class ArrowSprite extends Sprite {
  ArrowSprite([game]) : super(
    game: game,
    x: 0,
    y: 0,
    image: 'arrow.png',
    alive: false,
    width: 32,
    height: 32,
    speed: 5,
    frameColumns: 1,
    movesPerTick: 1,
    projectile: true
  ) {}
}
