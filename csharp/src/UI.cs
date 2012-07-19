using System;
using System.Drawing;
using System.Windows.Forms;

namespace SimpleRpg {

	// Represents the visual display of our UI which lets you play games, etc.
	public class UI : Form {

		static readonly Size SIZE = new Size(width: 800, height: 600);

		Game Game { get; set; }

		public PictureBox GameBoard { get; set; }

		public UI() {
			InitializeComponent();

			Game = new Game(){ UI = this };

			Console.WriteLine("Done constructing UI");
		}

		void InitializeComponent() {
			Text            = "Simple RPG";
			MaximizeBox     = false;
			Size            = new Size(SIZE.Width + 15, SIZE.Height + 35);
			FormBorderStyle = FormBorderStyle.FixedSingle;

			GameBoard = new PictureBox(){
				Parent      = this,
				Size        = SIZE,
				Location    = new Point(5, 5),
				BorderStyle = BorderStyle.Fixed3D,
				BackColor   = Color.Black
			};

			Shown      += (sender, e) => Game.Start();
			FormClosed += (sender, e) => Game.Stop();
			KeyDown    += (sender, e) => Game.SendKey(e.KeyCode);
		}
	}
}
