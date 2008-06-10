package com.googlecode.flashlr.parser.batch
{
	
	import com.googlecode.flashlr.scanner.Token;
	
	
	public class TerminalNode extends Node
	{
		
		public var token:Token;


		public function TerminalNode( index:int )
		{
			super( index );
		}


		override public function get length( ):int
		{
			return 1;
		}
		
		
		
		
		
		override public function toString( ):String
		{
			
			return "T " + token.image;
		}
		
		
	}

}