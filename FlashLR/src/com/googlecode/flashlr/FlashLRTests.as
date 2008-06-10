package com.googlecode.flashlr
{
	import flexunit.framework.TestSuite;
	
	import com.googlecode.flashlr.parser.model.QuantifiedNameTest;
	
	
	/**
	 * @private
	 * 
	 */	
	public class FlashLRTests extends TestSuite
	{


		public function FlashLRTests( )	
		{
				
			addTestSuite( QuantifiedNameTest );

		}



	}


}