using System;
using System.Drawing;
using System.Windows.Forms;

namespace SimpleRpg {

	// Our first sprite.
	// Making this very specific to our Dragon.
	// We can extract out a Sprite baseclass later.
	public class DragonSprite {

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
	}
}
