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
		}

		void Setup() {
			IsOver = false;
			Surface = new Bitmap(UI.GameBoard.Width, UI.GameBoard.Height);
			UI.GameBoard.Image = Surface;
			Device = Graphics.FromImage(Surface);
			Bitmaps = new Dictionary<string, Bitmap> {
				{ "grass",  new Bitmap("assets/grass.bmp")  },
				{ "dragon", new Bitmap("assets/dragon.png") },
				{ "book",   new Bitmap("assets/book-cover.jpg") }
			};
		}

		void Teardown() {
			Bitmaps = null;
		}

		List<Rectangle> books = new List<Rectangle>();
		void Draw() {
			Device.DrawImageUnscaled(Bitmaps["grass"], 0, 0, UI.GameBoard.Width, UI.GameBoard.Height);

			// Add and draw some books, as an example ...
			if (Environment.TickCount % 5 == 0)
				books.Add(new Rectangle(location: new Point(Rand(max: UI.GameBoard.Width), Rand(max: UI.GameBoard.Height)), size: new Size(Rand(), Rand())));
			foreach (var rectangle in books)
				Device.DrawImageUnscaled(Bitmaps["book"], rectangle);

			UI.GameBoard.Image = Surface;
		}

		Random _rand = new Random();
		int Rand(int min = 0, int max = 100) {
			return _rand.Next(min, max);
		}

		void Main() {
			Console.WriteLine("Game.Main()");
			var lastFrameTick = 0;

			while (! IsOver) {
				var currentTick = Environment.TickCount;

				if (currentTick > (lastFrameTick + 16)) { // 60FPS
					lastFrameTick = currentTick;
					Draw(); // Draw on Surface
					Application.DoEvents(); // Unblock the UI
				} else {
					Thread.Sleep(1); // Throttle the CPI
				}
			}

			Teardown();
			Application.Exit();
		}

		// Update game state
		void Update(int unused) {
		}
	}
}
