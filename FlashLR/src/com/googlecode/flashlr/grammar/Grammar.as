package com.googlecode.flashlr.grammar
{
	import com.googlecode.flashlr.utils.RegExpUtil;
	
	
	
	
	
	
	
	/**
	 * 
	 * 
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class Grammar
	{
	
	
		/**
		 * holds all productions by name
		 */	
		private var productions:Object = {};
		
		
		
		/**
		 * holds all productions in precedence order:
		 * keywords, nonterminals, terminals
		 */		
		private var orderedProductions:Array = [];
		
		
		
		private var _compiled:Boolean;
		public function get compiled():Boolean
		{
			return _compiled;
		}


		
		private var _caseInsensitiveKeywords:Boolean;
		public function get caseInsensitiveKeywords():Boolean
		{
			return _caseInsensitiveKeywords;
		}


		
		private var rootProductionName:String;
		private var _rootProduction:Production;
		
		/**
		 * Returns the root production.
		 * This is most probably a Non Terminal. The opposite does not make
		 * sense but it is not invalid either
		 * 
		 * @return 
		 * 
		 */		
		public function get rootProduction():Production
		{
			return _rootProduction;
		}

		
		
		/**
		 * 
		 * @param caseInsensitiveKeywords
		 * @param rootProductionName if left empty, the first declared production is used by default
		 * 
		 */		
		public function Grammar( caseInsensitiveKeywords:Boolean = false, rootProductionName:String = null )
		{
			_caseInsensitiveKeywords = caseInsensitiveKeywords;	
			this.rootProductionName = rootProductionName;
		}
	
	

		public function getProduction( name:String ):Production
		{
			return productions[ name ] ? productions[ name ] : null;		
		}
		
		
		public function getTerminal( name:String ):Terminal
		{
			return ( getProduction( name ) as Terminal );
			// this will return null if the production is null or NonTerminal
		
		}
		
		public function getNonTerminal( name:String ):NonTerminal
		{
			return ( getProduction( name ) as NonTerminal );
			// this will return null if the production is null or Terminal
		}
	
	
	
	
		/**
		 * 
		 * shortcut
		 * 
		 * @param name
		 * @param expression
		 * @param flags
		 * @param re used to circumvent a UNICODE bug in flash player 9. you can pass an explicit regexp and it will be passed to the scanner as-is. Will be removed someday
		 * @return 
		 * 
		 */	
		public function t( name:String, expression:String, flags:String = null, re:RegExp = null ):Boolean
		{
			return declareTerminal( name, expression, flags );
		}



		/**
		 * 
		 * @param name
		 * @param expression
		 * @param flags
		 * @return 
		 * 
		 */
		public function declareTerminal( name:String, expression:String, flags:String = null ):Boolean
		{
			if ( productions[ name ] )
				return false;
			productions[ name ] = new Terminal( this, name, expression, flags );
			
			orderedProductions.push( productions[ name ] ); // KLUDGE
			
			return true;
		}
	
	



		/**
		 * 
		 * shortcut
		 * 
		 * @param name
		 * @param expression
		 * @return 
		 * 
		 */
		public function nt( name:String, expression:String ):Boolean
		{
			return declareNonTerminal( name, expression );	
		}


		/**
		 * 
		 * @param name
		 * @param expression
		 * @return 
		 * 
		 */	
		public function declareNonTerminal( name:String, expression:String ):Boolean
		{
			if ( productions[ name ] )
				return false;
			productions[ name ] = new NonTerminal( this, name, expression );

			orderedProductions.push( productions[ name ] ); // KLUDGE

			return true;
		}
		
		
		
		
		/**
		 * 
		 * Called internally when the non terminal productions are replacing the keywords mentioned
		 * 
		 * @param keyword
		 * @return 
		 * 
		 */		
		internal function getOrCreateKeywordTerminal( keyword:String ):Terminal
		{
			var name:String;

			// is it already created?			
			for ( name in name2keyword )
				if ( name2keyword[ name ] == keyword )
					return getTerminal( name );									
			
			// first time they ask for this keyword... create it				
			name = generateNewKeywordName();
			var expression:String = RegExpUtil.escapeSpecialRegExpChars( keyword );
			var flags:String = caseInsensitiveKeywords ? "i" : ""; // remember that expanded and global are added by default
			var terminal:Terminal = new Terminal( this, name, expression, flags );		
			terminal._isKeyword = true;

			name2keyword[ name ] = keyword;
			productions[ name ] = terminal;
			
			orderedProductions.unshift( terminal ); // keywords go on top, they take precedence over all other productions ( when there is a tie )
			
			return terminal;
		}
		private var name2keyword:Object = {};
		
		
		
		private var serial:int = 0; // used to generate some names
		private function generateNewKeywordName( ):String
		{
			var name:String;
			while ( true )	{
				name = "KW" + (serial++);
				if ( ! productions[ name ] ) // OK, it is not used
					break;
			}
			return name;	
		}
	
	
	
		/**
		 * 
		 * called after all the productions have been declared.
		 * will perform some tests and processing
		 * 
		 */	
		public function init():void
		{
			// determine root production ( this is done here because after processing keywords we will tamper the order )
			if ( rootProductionName )
				_rootProduction = productions[ rootProductionName ] as Production;
			else
				_rootProduction = orderedProductions[ 0 ] as Production;
			
			
			// process keywords
			for each ( var nt:NonTerminal in getNonTerminals() )
			{
				nt.replaceKeywordsWithTerminals();// this will generate some more terminals ( keywords )		
			}
			
		}
	
	
		
		
		public function getNonTerminals():Array
		{
			var res:Array = [];
			for each ( var prod:Production in orderedProductions )
				if ( prod is NonTerminal )
					res.push( prod );
			return res;			
		}
		
		
		public function getTerminals():Array
		{
			var res:Array = [];
			for each ( var prod:Production in orderedProductions )
				if ( prod is Terminal )
					res.push( prod );
			return res;		
		}
		
		
		
		
		
		
		
		

		
		private function recursionTest():void
		{

			// STUB ( for now we are counting on well formedness )
		
		}
		
		

	}
	

}