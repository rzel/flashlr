package com.googlecode.flashlr.grammar
{
	
	import com.googlecode.flashlr.utils.RegExpUtil;
	
	
	// abstract
	public class Production
	{
	
	
		private var _grammar:Grammar;
		public function get grammar():Grammar
		{
			return _grammar;		
		}
	
		private var _name:String;
		public function get name():String
		{
			return _name;		
		}
	
		protected var _expression:String;
		public function get expression():String
		{
			return _expression;		
		}
	
	
	
		public function Production( grammar:Grammar, name:String, expression:String )
		{
			_grammar 		= grammar;
			_name 			= name;
			_expression 	= expression;
		}





		public function toString():String
		{
		
			return "Production( " + name + " ) ::= " + expression; 
					
		
		}
		
	}
	
}