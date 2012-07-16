using System;
using System.Linq;
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
		Timer.Tick += (src,e) => {
			DrawImage();
			Box.Image = Surface; // refresh
		};
	}

	void DrawLine() {
		Device.DrawLine(RandomPen(), RandomPoint(), RandomPoint());
	}

	void DrawRectangle() {
		Device.DrawRectangle(RandomPen(), RandomRectange());
	}

	string[] texts = new string[] {
		"Hello world",
		"Foo and bar and then foo and some more bar and then foo!",
		"The cheese stands alone"
	};
	void DrawText() {
		var text = texts[Rand(0, texts.Length - 1)];
		var font = new Font(familyName: "Times New Roman", emSize: Rand(5, 50), style: FontStyle.Regular, unit: GraphicsUnit.Pixel);
		Device.DrawString(text, font, RandomBrush(), RandomPoint());
	}

	void DrawImage() {
		var flipOptions = Enum.GetValues(typeof(RotateFlipType)).OfType<RotateFlipType>().ToList();
		var image = new Bitmap(filename: "assets/book-cover.jpg");
		image.RotateFlip(flipOptions[Rand(0, flipOptions.Count - 1)]);
		Device.DrawImage(image, RandomRectange());
	}

	Pen RandomPen() { return new Pen(color: RandomColor(), width: Rand(2, 8)); }
	Color RandomColor() { return Color.FromArgb(100, Rand(), Rand(), Rand()); }
	Brush RandomBrush() { return new SolidBrush(color: RandomColor()); }
	Point RandomPoint() { return new Point(x: Rand(0, Size.Width), y: Rand(0, Size.Height)); }
	Rectangle RandomRectange() { return new Rectangle(location: RandomPoint(), size: new Size(Rand(10, 100), Rand(10, 100))); }

	int Rand(int min = 0, int max = 255) { return _rand.Next(min, max); }
}
