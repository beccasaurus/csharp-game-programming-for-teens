using System;
using System.Drawing;
using System.Windows.Forms;

namespace SimpleRpg {

	// Our first sprite.
	// Making this very specific to our Dragon.
	// We can extract out a Sprite baseclass later.
	public class DragonSprite {

		int frameRow = 0;

		public int X { get; set; }
		public int Y { get; set; }
		public int Width { get; set; }
		public int Height { get; set; }

		public DragonSprite() {
			X = 0;
			Y = 0;
			Height = 128;
			Width = 128;
		}

		// TODO make sure we can't leave the board  :P
		public void Up()    { frameRow = 0; Y -= 10; }
		public void Down()  { frameRow = 4; Y += 10; }
		public void Left()  { frameRow = 6; X -= 10; }
		public void Right() { frameRow = 2; X += 10; }

		int lastTick = 0;
		int frameRate = 60;
		int columns = 8;
		int currentColumn = 0;
		public void Draw(Game game) {
			var tick = Environment.TickCount;
			if (tick > lastTick + frameRate) {
				lastTick = tick;
				currentColumn++;
				if (currentColumn >= columns)
					currentColumn = 0;
			}

			var spriteFrame = new Rectangle(currentColumn * 256, frameRow * 256, 256, 256); // need to update which sprite to use based on direction and current time ...

			game.Device.DrawImage(
				image: game.Bitmaps["dragon"],
				destRect: new Rectangle(X, Y, Width, Height),
				srcRect: spriteFrame,
				srcUnit: GraphicsUnit.Pixel
			);
		}
	}
}
