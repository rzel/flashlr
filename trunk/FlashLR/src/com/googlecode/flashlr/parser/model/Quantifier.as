package com.googlecode.flashlr.parser.model
{
	
	
	public class Quantifier extends UnaryOperator
	{
		
		public var min:int;
		
		public var max:int;
		
		public var greedy:Boolean;
		
		
		public function Quantifier( min:int, max:int, greedy:Boolean = true )
		{
			this.min		= min;
			this.max		= max;
			this.greedy		= greedy;
		}
		
		
		
		override public function toString():String
		{
			
			var notice:String = "";
			if ( operand == null )
			{
				notice = "WARNING: I AM A QUANTIFIER WITH NO OPERAND!";
			}
			
			return "Quantifier( " + min + "," + max + " ) " + notice + " " + super.toString(); 
		
		}
		
		
	}

}