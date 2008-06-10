package com.googlecode.flashlr.parser.model
{
	import com.googlecode.flashlr.grammar.Terminal;
	
	
	/**
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class TerminalMatcher extends Expression
	{
		
		public function TerminalMatcher( production:Terminal )
		{
			this.production = production;	
		}
		
		
		override public function toString():String
		{
	
			return "TerminalMatcher, " + super.toString();
	
		}

	}
	
}