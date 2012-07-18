using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;

namespace SimpleRpg {

	public class Game {

		// For now, we have direct access to the Form.
		// As the game evolves, the design will evolve.
		// Eventually, we'll loosen this coupling.
		public UI UI { get; set; }

		Bitmap Surface { get; set; }

		Graphics Device { get; set; }

		public bool IsOver { get; set; }

		public void Start() {
			IsOver = false;
			Surface = new Bitmap(UI.GameBoard.Width, UI.GameBoard.Height);
			UI.GameBoard.Image = Surface;
			Device = Graphics.FromImage(Surface);

			Main();
		}

		public void Stop() {
			IsOver = true;
		}

		public void SendKey(Keys key) {
		}

		void Main() {
			var bitmaps = new Dictionary<string, Bitmap> {
				{ "grass",  new Bitmap("assets/grass.bmp")  },
				{ "dragon", new Bitmap("assets/dragon.png") }
			};

			Device.DrawImageUnscaled(bitmaps["grass"], 0, 0, UI.GameBoard.Width, UI.GameBoard.Height);
		}
	}
}
