using System;
using System.Windows.Forms;

namespace SimpleRpg {
	public class Program {

		[STAThread]
		public static void Main(string[] args) {
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Application.Run(new UI());
		}
	}
}
