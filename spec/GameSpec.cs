using System;
using NUnit.Framework;

namespace SimpleRpg.Specs {

	[TestFixture]
	public class GameSpec : Spec {

		[Test]
		public void it_should_exist() {
			new Game().Should(Be.TypeOf<Game>());
		}
	}
}
