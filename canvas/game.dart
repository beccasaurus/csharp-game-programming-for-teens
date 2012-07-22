#import('dart:html');
#import('dart:math');

void main() {
  new Game().run();
}

class Game {
  Document doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  int width;
  int height;
  bool stopped = false;
  Random random;

  Game() {
    canvas = document.query('#canvas');
    ctx = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    random = new Random();

    window.console.log(this);
  }

  void run() => start();

  void start() {
    print("starting game");
    window.requestAnimationFrame(loop);
  }

  void loop(int time) {
    update();
    draw();
    window.requestAnimationFrame(loop);
  }

  update() {
    ctx.fillStyle = "#FF00FF";
  }

  draw() {
    ctx.fillRect(
      100 + random.nextInt(200),
      100 + random.nextInt(200),
      100 + random.nextInt(200),
      100 + random.nextInt(200)
    );
  }
}
