package com.googlecode.flashlr.parser.model
{
	
	
	
	public class Sequence extends Expression
	{
		
		
		
		public var children:Array = [];
		
		
		
		
		override public function get subExpressions():Array
		{
			return children;
		}
		
		
		
		
		
		override public function toString():String
		{

			return "Sequence()" + super.toString();

		}
	
		
		
	}

}