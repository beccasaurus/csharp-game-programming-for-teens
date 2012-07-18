using System;
using System.Drawing;
using System.Windows.Forms;

namespace SimpleRpg {

	// Our first sprite.
	// Making this very specific to our Dragon.
	// We can extract out a Sprite baseclass later.
	public class DragonSprite {

		int _frameRow = 0;

		public int X { get; set; }
		public int Y { get; set; }
		public int Width { get; set; }
		public int Height { get; set; }

		public DragonSprite() {
			X = 0;
			Y = 0;
			Height = 100;
			Width = 100;
		}

		// TODO make sure we can't leave the board  :P
		public void Up()    { _frameRow = 0; Y -= 10; }
		public void Down()  { _frameRow = 4; Y += 10; }
		public void Left()  { _frameRow = 6; X -= 10; }
		public void Right() { _frameRow = 2; X += 10; }

		int lastTick;
		public void Draw(Game game) {
			var spriteFrame = new Rectangle(0, _frameRow * 256, 256, 256); // need to update which sprite to use based on direction and current time ...

			game.Device.DrawImage(
				image: game.Bitmaps["dragon"],
				destRect: new Rectangle(X, Y, Width, Height),
				srcRect: spriteFrame,
				srcUnit: GraphicsUnit.Pixel
			);
		}
	}
}
