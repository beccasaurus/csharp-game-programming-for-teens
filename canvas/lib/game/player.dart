class Player {
  Sprite sprite;

  Player([Sprite sprite]) {
    this.sprite = sprite;
  }

  shoot() => sprite.animateOnce();

  update(tick) {
    updateDirection();
    sprite.update(tick);
  }

  updateDirection() => sprite.direction = Direction.fromKeys(new List<KeyName>.from(sprite.game.keysPressed));

  draw(tick) => sprite.draw(tick);
}
