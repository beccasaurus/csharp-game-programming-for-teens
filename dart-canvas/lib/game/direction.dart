/**
 * Represents a cardinal direction, eg. North, South, East, West
 */
class Direction {

  static final Direction north     = const Direction('North', 0, -1, const [KeyName.UP]);
  static final Direction south     = const Direction('South', 0, 1, const [KeyName.DOWN]);
  static final Direction east      = const Direction('East', 1, 0, const [KeyName.RIGHT]);
  static final Direction west      = const Direction('West', -1, 0, const [KeyName.LEFT]);
  static final Direction northEast = const Direction('North East', 1, -1, const [KeyName.UP, KeyName.RIGHT]);
  static final Direction northWest = const Direction('North West', -1, -1, const [KeyName.UP, KeyName.LEFT]);
  static final Direction southEast = const Direction('South East', 1, 1, const [KeyName.DOWN, KeyName.RIGHT]);
  static final Direction southWest = const Direction('South West', -1, 1, const [KeyName.DOWN, KeyName.LEFT]);

  // NOTE: 2-part directions are intentionally listed first here (coupled to key checking).  Do not change (without making sure fromKeys still works).
  static final List<Direction> all = const [ northEast, northWest, southEast, southWest, north, south, east, west ];

  int hashCode() => all.indexOf(this);

  static Direction fromName(String name) {
    for (var direction in all)
      if (direction.name == name)
        return direction;
  }

  static Direction fromKeys(List<KeyName> keys) {
    for (var direction in all) {
      bool match = direction.keys.every((key) => keys.indexOf(key) > -1);
      if (match)
        return direction;
    }
    return null;
  }

  final String name;
  final int xVelocity;
  final int yVelocity;
  final List<KeyName> keys;

  const Direction(this.name, this.xVelocity, this.yVelocity, this.keys);

  String toString() => name;
}
