using System;
using NUnit.Framework;

namespace SimpleRpg.Specs {

	[TestFixture]
	public class WhateverSpec : Spec {

		[Test]
		public void should_pass() {
			true.ShouldEqual(true);
		}

		[Test]
		public void should_fail() {
			true.ShouldEqual(false);
		}
	}
}
