using System;
using System.IO;
using NUnit.Framework;

namespace SimpleRpg.Specs {

	/// <summary>
	/// Global Before and After Hooks for every [Test] in the SimpleRpg.Specs namespace
	/// </summary>
	[SetUpFixture]
	public class SpecsSetup {

		[SetUp]
		public void BeforeAll() {
		}

		[TearDown]
		public void AfterAll() {
		}
	}

	/// <summary>
	/// Base class for our specs.  Useful for sharing a [SetUp] and whatnot.
	/// </summary>
	public class Spec {

		[SetUp]
		public void BeforeEach() {
		}

		[TearDown]
		public void AfterEach() {
		}
	}
}
