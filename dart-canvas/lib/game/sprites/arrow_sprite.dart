class ArrowSprite extends Sprite {
  static Map<Direction, List<int>> _animationFramesByDirection;
  static get animationFramesByDirection() {
    if (_animationFramesByDirection == null) {
      _animationFramesByDirection = new Map<Direction, List<int>>();
      _animationFramesByDirection[Direction.north]     = [0, 0];
      _animationFramesByDirection[Direction.east]      = [8, 0];
      _animationFramesByDirection[Direction.south]     = [5, 1];
      _animationFramesByDirection[Direction.west]      = [2, 2];
      _animationFramesByDirection[Direction.northEast] = [4, 0];
      _animationFramesByDirection[Direction.northWest] = [6, 2];
      _animationFramesByDirection[Direction.southEast] = [1, 1];
      _animationFramesByDirection[Direction.southWest] = [9, 1];
    }
    return _animationFramesByDirection;
  }

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

  calculateAnimationFrame() {
    var xAndY = animationFramesByDirection[direction];
    animationX = xAndY[0] * width;
    animationY = xAndY[1] * height;
  }

  move() {
    super.move();
    if (x == 0 || y == 0 || x == xMax || y == yMax)
      alive = false; // kill arrow when it goes out of bounds
  }
}
