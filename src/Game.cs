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

		public Graphics Device { get; set; }

		public Dictionary<string, Bitmap> Bitmaps { get; set; }

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

		// TODO capture combinations like Right+Down to move diagonally.
		public void SendKey(Keys key) {
			switch (key) {
				case Keys.Escape: Stop(); break;
				case Keys.Up: Dragon.Up(); break;
				case Keys.Down: Dragon.Down(); break;
				case Keys.Left: Dragon.Left(); break;
				case Keys.Right: Dragon.Right(); break;
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
			Dragon = null;
			UI = null;
		}

		void Draw() {
			DrawBackground();
			Dragon.Draw(game: this);
			UI.GameBoard.Image = Surface;
		}

		void DrawBackground() {
			Device.DrawImageUnscaled(Bitmaps["grass"], 0, 0, UI.GameBoard.Width, UI.GameBoard.Height);
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
			// Application.Exit();
			Environment.Exit(0);
		}

		// Update game state
		void Update(int unused) {}
	}
}
