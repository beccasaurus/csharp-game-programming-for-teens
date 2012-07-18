using System;
using System.Drawing;
using System.Windows.Forms;

namespace SimpleRpg {

	// Represents the visual display of our UI which lets you play games, etc.
	public class UI : Form {

		static readonly Size SIZE = new Size(width: 800, height: 600);

		PictureBox GameBoard { get; set; }

		public UI() {
			InitializeComponent();
		}

		void InitializeComponent() {
			Text = "Simple RPG";
			MaximizeBox = false;
			FormBorderStyle = FormBorderStyle.FixedSingle;
			Size = new Size(SIZE.Width + 6, SIZE.Height + 28);

			GameBoard = new PictureBox();
			GameBoard.Parent = this;
			GameBoard.Size = SIZE;
		}
	}
}
