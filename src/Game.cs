using System;
using System.Drawing;
using System.Threading;
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

		Dictionary<string, Bitmap> Bitmaps { get; set; }

		DragonSprite Dragon { get; set; }

		public bool IsOver { get; set; }

		public Game() {
			Console.WriteLine("Done constructing Game");
		}

		public void Start() {
			Console.WriteLine("Game.Start()");
			Setup();
			Main();
		}

		public void Stop() {
			Console.WriteLine("Game.Stop()");
			IsOver = true;
		}

		public void SendKey(Keys key) {
			if (key == Keys.Down)
				Console.WriteLine("DOWN!");
			Console.WriteLine(key);

			switch (key) {
				case Keys.Escape: Stop(); break;
				case Keys.Up: Dragon.Y -= 10; break;
				case Keys.Down: Dragon.Y += 10; break;
				case Keys.Left: Dragon.X -= 10; break;
				case Keys.Right: Dragon.X += 10; break;
			}
		}

		void Setup() {
			IsOver = false;
			Surface = new Bitmap(UI.GameBoard.Width, UI.GameBoard.Height);
			Device = Graphics.FromImage(Surface);
			Bitmaps = new Dictionary<string, Bitmap> {
				{ "grass",  new Bitmap("assets/grass.bmp")  },
				{ "dragon", new Bitmap("assets/dragon.png") }
			};
			Dragon = new DragonSprite();
		}

		void Teardown() {
			Bitmaps = null;
		}

		void Draw() {
			DrawBackground();
			DrawDragonSprite();
			UI.GameBoard.Image = Surface;
		}

		void DrawBackground() {
			Device.DrawImageUnscaled(Bitmaps["grass"], 0, 0, UI.GameBoard.Width, UI.GameBoard.Height);
		}

		void DrawDragonSprite() {
			Device.DrawImage(
				image: Bitmaps["dragon"],
				destRect: new Rectangle(Dragon.X, Dragon.Y, Dragon.Width, Dragon.Height),
				srcRect: new Rectangle(0, 0, 256, 256),
				srcUnit: GraphicsUnit.Pixel
			);
		}

		void Main() {
			Draw();
			var lastFrameTick = 0;

			while (! IsOver) {
				var currentTick = Environment.TickCount;

				// Update(currentTick - lastFrameTick);

				if (currentTick > (lastFrameTick + 16)) { // 60FPS
					lastFrameTick = currentTick;
					Draw(); // Draw on Surface
					Application.DoEvents(); // Unblock the UI
				} else {
					Thread.Sleep(1); // Throttle the CPI
				}
			}

			Teardown();
			Console.WriteLine("EXIT");
			Application.Exit();
		}

		// Update game state
		void Update(int unused) {}
	}
}
