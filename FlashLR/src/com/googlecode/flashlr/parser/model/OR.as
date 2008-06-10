package com.googlecode.flashlr.parser.model
{
	
	/**
	 * 
	 * 
	 * 
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class OR extends BinaryOperator
	{

	
		private var _shortCircuit:Boolean;
		public function get shortCircuit( ):Boolean
		{
			return _shortCircuit;
		}
		

		
		public function OR( shortCircuit:Boolean = false )
		{
			_shortCircuit = shortCircuit;
		}
	


		override public function toString():String
		{
			return "OR( )" + super.toString();		
		}
		
	}
	
}