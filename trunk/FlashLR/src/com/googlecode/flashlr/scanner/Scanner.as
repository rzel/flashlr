package com.googlecode.flashlr.scanner
{

	import flash.utils.Dictionary;
	
	import com.googlecode.flashlr.grammar.Grammar;
	import com.googlecode.flashlr.grammar.Terminal;
	import com.googlecode.flashlr.utils.RegExpUtil;
	


	/**
	 * 
	 * A simple scanner that runs to completion over a string using built-in RegExps
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */
	public class Scanner
	{


		private var _grammar:Grammar;
		public function get grammar():Grammar
		{
			return _grammar;
		}
	


		private var terminals:Array = [];

		private var res:Array = [];

		private var precedence:Dictionary = new Dictionary();

		
		public function Scanner( grammar:Grammar )
		{
			_grammar = grammar;
			
			// we fetch the terminals once so we don't have to ask the grammar over and over again
			terminals = grammar.getTerminals();
			
			// populate our regular expressions ( and nesting precedence ) right away
			for each ( var terminal:Terminal in terminals )
			{
				
				res.push( terminal2re( terminal ) );
				
				var nestedRegExps:Array = [];
								
				for each ( var nestedTerminalName:String in terminal.referencedTerminalNamesTransitiveClosure )
				{
					nestedRegExps.push( terminal2re( grammar.getTerminal( nestedTerminalName ) ) ); 					
				}
				
				precedence[ terminal2re( terminal ) ] = nestedRegExps;
			
			}
			
			
			// keyword precedence ( RULE: a keyword beats any other regex... )
			for each ( var kwTerminal:Terminal in terminals )
			{
				if ( kwTerminal.isKeyword ) // a keyword terminal beats ALL other matches ( but itself )
				{
					var precedes:Array = [];
					for each ( var regExp:RegExp in res )
						if ( regExp != terminal2re( kwTerminal ) )
							precedes.push( regExp );
							
					precedence[ terminal2re( kwTerminal ) ] = precedes; // we won't step over anything because keywords don't have nested terminals
				}	
			}
			
		}




		public function scan( str:String ):ITokenStream
		{
			
			var tokens:Array = [];
			
			var results:Array = RegExpUtil.executeDisjointRegExps( res, str, precedence );
			// var results:Array = RegExpUtil.executeDisjointRegExps( res, str );
			
			
			for each ( var result:Array in results )
			{
				// we can find out which regexp matched and then get the corresponding terminal
				var terminal:Terminal = re2terminal( result.regExp as RegExp );		
			
				var matchedString:String = String( result[ 0 ] );
								
				var token:Token = new Token( terminal, matchedString, result.index as int );				
				
				// TODO: we should attach the nested Terminal matches to the token
				// these are available in the result object but we are missing the correct names for
				// each pattern group. This is not critical though, just a nice to have feature
				tokens.push( token );
			
			}
			
			return new ArrayTokenStream( tokens );

		}
		
		
		
		
		
		
		
		
		
		
		
		/////////////////////////////////////////////////////////////////////
		////////////////// terminals to regular expressions /////////////////
		/////////////////////////////////////////////////////////////////////
		
		
		private var terminal2reMap:Dictionary = new Dictionary();
		private function terminal2re( terminal:Terminal ):RegExp
		{
			// building regular expressions is the Scanner's bussiness
			//   ( the grammar should remain merely declarative )
			// if we were to implement an incremental scanner we would probably use a different strategy
			
			if ( ! terminal2reMap[ terminal ] )
			{
				var flags:String = terminal.flags;
				
				// the expressions are expanded ( this means we NEED to set the 'x' flag )
				if ( flags.indexOf( "x" ) == -1 )
					flags += "x";
				
				// ...and of course they MUST be set to global
				if ( flags.indexOf( "g" ) == -1 )
					flags += "g";


				var re:RegExp = new RegExp( terminal.dereferencedExpression, flags );
				
				// cache
				terminal2reMap[ terminal ] = re;
				re2terminalMap[ re ] = terminal;
				
			}
			
			return terminal2reMap[ terminal ] as RegExp;
		}


		private var re2terminalMap:Dictionary = new Dictionary();
		private function re2terminal( re:RegExp ):Terminal
		{
			return re2terminalMap[ re ] as Terminal;

		}


	}

}