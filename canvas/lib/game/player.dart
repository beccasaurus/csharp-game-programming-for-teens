class Player {
  Sprite sprite;
  Sprite arrow;

  Player([Sprite sprite, Sprite arrow]) {
    this.sprite = sprite;
    this.arrow = arrow;
  }

  shoot() => sprite.animateOnce(() {
    arrow.direction = sprite.direction;
    arrow.x = sprite.x + 30;;
    arrow.y = sprite.y + 30;
    arrow.alive = true;
  });

  update(tick) {
    updateDirection();
    sprite.update(tick);
  }

  updateDirection() => sprite.direction = Direction.fromKeys(new List<KeyName>.from(sprite.game.keysPressed));

  draw(tick) => sprite.draw(tick);
}
