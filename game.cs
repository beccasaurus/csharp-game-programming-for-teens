using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;

public class Program {
	public static void Main(string[] args) {
		Application.Run(new DrawingLinesForm());
	}
}

public class DrawingLinesForm : Form {

	Random _rand = new Random();

	PictureBox Box     { get; set; }
	Bitmap     Surface { get; set; }
	Graphics   Device  { get; set; }
	Timer      Timer   { get; set; }

	public DrawingLinesForm() {
		InitializeComponents();
		var disposables = new List<IDisposable>(){ Device, Surface, Timer };
		this.FormClosed += (s,e) => disposables.ForEach(o => o.Dispose());
	}

	void InitializeComponents() {
		Text = "C# Gaming";
		FormBorderStyle = FormBorderStyle.FixedSingle;
		MaximizeBox = false;
		Size = new Size(width: 600, height: 400);

		Box = new PictureBox() {
			Parent = this,
			Dock = DockStyle.Fill,
			BackColor = Color.Black
		};

		Surface = new Bitmap(this.Size.Width, this.Size.Height); // Make a Surface to draw on
		Box.Image = Surface; // Tell the PictureBox to render our Bitmap Surface
		Device = Graphics.FromImage(Surface); // Get the surface's Graphics interface (has Draw*() methods)

		Timer = new Timer() { Interval = 20, Enabled = true };
		Timer.Tick += (src,e) => DrawLine();
	}

	public void DrawLine() {
		Device.DrawLine(RandomPen(), RandomPoint(), RandomPoint());
		Box.Image = Surface; // refresh
	}

	Pen RandomPen() { return new Pen(color: RandomColor(), width: Rand(2, 8)); }

	Color RandomColor() { return Color.FromArgb(100, Rand(), Rand(), Rand()); }

	Point RandomPoint() { return new Point(x: Rand(0, Size.Width), y: Rand(0, Size.Height)); }

	int Rand(int min = 0, int max = 255) { return _rand.Next(min, max); }
}
