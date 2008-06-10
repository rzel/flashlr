package com.googlecode.flashlr.scanner
{
	
	/**
	 * 
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class ArrayTokenStream implements ITokenStream
	{
		
		private var tokens:Array;

		public function ArrayTokenStream( tokens:Array )
		{
			this.tokens = tokens;
		}
		

		public function next():Token
		{
			if ( tokens.length == 0 )
				return null
			
			return tokens.shift() as Token;
		}
		
		
		
		public function hasNext():Boolean
		{
			return ( tokens.length > 0 );
		}
		
	
	}
	

}