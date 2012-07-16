using System;
using System.Windows.Forms;

public class Program {
	public static void Main(string[] args) {
		Application.Run(new MainForm());
	}
}

public class MainForm : Form {
	public MainForm() {
		Text = "C# Gaming";
	}
}
