package com.googlecode.flashlr.utils
{
	import flexunit.framework.TestCase;
	
	public class RegExpUtilTest extends TestCase
	{
		
		public function replaceCallBack1( result:* ):String
		{
			return "";
		}
		public function replaceCallBack2( result:String ):String
		{
			return result.substring( 2 );
		}
		public function testReplaceWithCallback():void
		{
			var r1:RegExp = / THIS /xg
			var str:String = "Remove THIS";
			
			assertTrue( "Expecting 'Remove '", RegExpUtil.replaceWithCallback( r1, str, replaceCallBack1 ) == "Remove " );
			
			assertTrue( "Expecting 'Remove IS'", RegExpUtil.replaceWithCallback( r1, str, replaceCallBack2 ) == "Remove IS" );
		}

	}
}