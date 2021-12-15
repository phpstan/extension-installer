<?php

namespace App;

use PHPUnit\Framework\TestCase;

class FooTest extends TestCase
{

	public function testFoo(?\stdClass $std): void
	{
		$this->assertNotNull($std);
		$this->requireStd($std);
	}

	private function requireStd(\stdClass $std): void
	{

	}

	/**
	 * @return string
	 */
	protected function testRootPackageConfigInstall()
	{
		return 10;
	}

}
