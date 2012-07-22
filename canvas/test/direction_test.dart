class DirectionTest {
  static run() {

    test('helper fields are available for all directions', (){
      expect(Direction.north.name, equals('North'));
      expect(Direction.northWest.name, equals('North West'));
    });

    test('can get direction from name', (){
      expect(Direction.fromName('North'), equals(Direction.north));
      expect(Direction.fromName('North East'), equals(Direction.northEast));
    });

    test('can get direction from keys', (){
      expect(Direction.fromKeys([KeyName.UP]), equals(Direction.north));
      expect(Direction.fromKeys([KeyName.RIGHT]), equals(Direction.east));
      expect(Direction.fromKeys([KeyName.UP, KeyName.RIGHT]), equals(Direction.northEast));
    });

    test('can get x/y velocities (-1,0,1) based on direction', (){
      expect(Direction.north.xVelocity, equals(0));
      expect(Direction.north.yVelocity, equals(-1)); // 'Go up' meaning up the Y axis (towards 0)

      expect(Direction.east.xVelocity, equals(1)); // Go along the X axis positively
      expect(Direction.east.yVelocity, equals(0));

      expect(Direction.northEast.xVelocity, equals(1)); // Go along the X axis positively
      expect(Direction.northEast.yVelocity, equals(-1)); // 'Go up' meaning up the Y axis (towards 0)
    });
  }
}
