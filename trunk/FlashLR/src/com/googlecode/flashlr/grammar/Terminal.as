package com.googlecode.flashlr.grammar
{
	
	import com.googlecode.flashlr.utils.RegExpUtil;
	
	
	/**
	 * 
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class Terminal extends Production
	{
	
	
	
		internal var _isKeyword:Boolean = false; // this is set on Grammar.init()
		public function get isKeyword():Boolean
		{
			return _isKeyword;
		}
	
	
	
	
		// TODO: what flags do we allow??
		private var _flags:String = "";
		public function get flags():String
		{
			return _flags;
		}

	
		public function Terminal( grammar:Grammar, name:String, expression:String, flags:String = null )
		{
			
			super( grammar, name, expression );

			if ( flags != null )
				_flags = flags;
				
		}
		
		

		
		/**
		 * 
		 * recursively dereference referenced Terminals
		 * 
		 * @return 
		 * 
		 */		
		public function get dereferencedExpression():String
		{
			
			var r:RegExp;
			
			if ( _dereferencedExpression == null )
			{
				
				var result:String = expression;
				
				// if we are terminals, we have to dereference the expression 			
				
				for each ( var referencedTerminalName:String in referencedTerminalNames )
				{
				
					var referencedTerminal:Terminal = grammar.getTerminal( referencedTerminalName );
	
					var referencedExpression:String = referencedTerminal.dereferencedExpression;
	
					result = result.replace( "{{" + referencedTerminalName + "}}", "(" + referencedExpression + ")" );
					
					// named groups are removed for now, until we figure a way to treat nesting ( names might repeat themselves )
					// result = result.replace( "{{" + referencedTerminalName + "}}", "(?P<" + referencedTerminalName + ">" + referencedExpression + ")" );
	
				}
			
				_dereferencedExpression = result;
			
			}
			
			return _dereferencedExpression;
		
		}
		// cache		
		private var _dereferencedExpression:String;
		

		
		
		


		/**
		 * 
		 * Referenced Terminals are those that occurr within the expression.
		 * The Grammar will need them to perform the recursion test ( not implemented yet )
		 * and to know which matches win when there is a tie ( this happens when the whole part of the expression is a subexpression )
		 * for example:  REFERENCE ::= URI | BNODE
		 * In that case, the three expressions will match at the same index and length.
		 * 
		 * TODO: cache
		 * 
		 * @return 
		 * 
		 */		
		public function get referencedTerminalNames():Array
		{
			return RegExpUtil.matchSubpattern( terminalReferenceWithinExpression, expression, 1 );
		}
		
		
		/**
		 * 
		 * 
		 * @return 
		 * 
		 */		
		public function get referencedTerminalNamesTransitiveClosure():Array
		{
			var result:Array = [];
			for each ( var n:String in referencedTerminalNames )
			{
				result.concat( grammar.getTerminal( n ).referencedTerminalNamesTransitiveClosure );	
			}		
			return result;		
		}
		
		
		
	
		/**
		 * TODO: we still have to implement escaping for this
		 */	
		internal static var terminalReferenceWithinExpression:RegExp = /\{\{([a-zA-Z_]+\w*)\}\}/g;	
	
	
		
	}
	
	
}