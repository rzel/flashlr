package com.googlecode.flashlr.parser.model
{
	
	
	
	import com.googlecode.flashlr.grammar.Production;
	
	
	
	public class Expression
	{
		

		/**
		 * Set only if this operator is related directly to a grammar production.
		 */			
		public var production:Production;
			
	
	
		public function get subExpressions( ):Array
		{
			return [ ];
		}
	
			
		
		public function toString():String
		{
		
			if ( production )
				return "'" + production.expression + "'"; 
		
			return "";
		
		}			
		
		
		
		
			
				
	}
	
}