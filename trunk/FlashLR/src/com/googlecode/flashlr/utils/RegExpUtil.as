package com.googlecode.flashlr.utils
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * 
	 * TODO: refactor to the x.* namespace once we modularize libraries
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class RegExpUtil
	{
		
		
		
		
		
		public static function replaceDisjointWithCallback( disjointRegExps:Array, str:String, callback:Function ):String
		{
		
			var results:Array = executeDisjointRegExps( disjointRegExps, str );
			return replaceResultsWithCallback( results, str, callback );
		
		}
		
		
		
		
		
		// KLUDGE
		public static function replaceResultsWithCallback( results:Array, str:String, callback:Function ):String
		{
			
			// we assume that the input is still here
			var offset:int = 0; // generated during replacement
			
			for each ( var result:Array in results )
			{
				
				var match:String = String( result[ 0 ] );
				var index:int = ( result.index as int ) + offset; // we correct right away
				
				
				var stringBeforeMatch:String = str.substr( 0, index );
				var stringAfterMatch:String = str.substr( index + match.length );
				
				var newValue:String = String( callback( result ) );
							
				str = stringBeforeMatch + newValue + stringAfterMatch;
							
				offset += ( newValue.length - match.length );			
			
			}
		
			var r:RegExp;
		
			return str;
		}
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * <pre>
		 * 
		 * function replaceCallback( result:* ):String
		 * {
		 * 		return "";
		 * }
		 * 
		 * </pre>
		 * 
		 * 
		 * 
		 * @param regExp
		 * @param str
		 * @param callback
		 * @param passCompleteObject
		 * 		If set to false ( default ) your callback function will receive the complete matched string.
		 * 		If set to true, your callback function will receive the result Object ( the one returned by RegExp.exec() ).	
		 * 
		 * @return 
		 * 
		 */		
		public static function replaceWithCallback( regExp:RegExp, str:String, callback:Function, passCompleteObject:Boolean = false ):String
		{
		
			while ( true )
			{
			
				var result:Array = regExp.exec( str );
							
				if ( result == null )
				{
					break;
				}
				
				var match:String = String( result[ 0 ] );
				var index:int = result.index as int;
				
				var stringBeforeMatch:String = str.substr( 0, index );
				var stringAfterMatch:String = str.substr( index + match.length );
				
				
				var newValue:String = String( callback(  passCompleteObject ? result : result[0] ) );
							
				str = stringBeforeMatch + newValue + stringAfterMatch;
							
				regExp.lastIndex += ( newValue.length - match.length );

			}		
		
		
			return str;
		
		}
		
		
		
		
		
		/**
		 * 
		 * Analog to String.match(), but will return an array of matches over the subpattern
		 * specified by subpatternIndex
		 * 
		 * @param regExp
		 * @param str
		 * @param subpatternIndex
		 * @param resetRegExpLastIndex
		 * @return 
		 * 
		 */		
		public static function matchSubpattern( regExp:RegExp, str:String, subpatternIndex:int, resetRegExpLastIndex:Boolean = true ):Array
		{
				
			if ( resetRegExpLastIndex )
				regExp.lastIndex = 0;
			
			var matches:Array = [];
			
			while ( true )
			{
				
				var result:Array = regExp.exec( str );
				if ( result == null )
					break;
				
				if ( result[ subpatternIndex ] )
				{
					matches.push( result[ subpatternIndex ] );				
				}
			
			}
			
			return matches;
		
		}
		
		
		
		
		
		/**
		 * 
		 * Will execute all the regExps and return an array of result objects ( the same object returned by the RegExp.exec method ).
		 * Each of these result objects can belong to a different RegExp, you can find that out by inspecting a new property ( result.regExp ).
		 * Returned results are selected like so:
		 * 
		 * - first, then longest ( TODO: explain this )
		 * 
		 * NOTE: all passed regExp lastIndex properties are left untouched
		 *   ( actually, changed and then restored to their initial value, whatever that was )
		 * 
		 * @param str
		 * @param regExps
		 * @param precedence
		 * @return 
		 * 
		 */		
		public static function executeDisjointRegExps( regExps:Array, str:String, precedence:Dictionary = null ):Array
		{

			var longestResultByIndex:Object = {};
			
			if ( precedence == null )
			{
				precedence = new Dictionary();
			}



			for each ( var regExp:RegExp in regExps )
			{
				
				
				
				// this is used for resolution when there is a tie
				var hasPrecedenceOver:ArrayCollection = new ArrayCollection([]); // we use arraycollection to get index ( i'm lazy )
				if ( precedence[ regExp ] is Array )
				{
					hasPrecedenceOver = new ArrayCollection( precedence[ regExp ] as Array );				
				}
				
				
				var originalLastIndex:int = regExp.lastIndex;
				// we need to reset all indexes
				regExp.lastIndex = 0;

				while ( true )
				{				
					
					
					
					var result:Object = regExp.exec( str );
					if ( result == null )
					{
						break;
					}
					

					// border case: EMPTY STRING
					// if the current regexp just matched the empty string, then its "lastIndex" property
					// is not automatically advanced. Unless we do it by hand, this would result in an infinite loop.
					if ( String( result[ 0 ] ).length == 0 )
					{
						regExp.lastIndex++;
					}


					
					result.regExp = regExp; // store a reference so our clients can retrieve the RegExp ( they will most likely need it )
					
					if ( longestResultByIndex[ result.index ] )
					{
						var currentMatch:String = String( result[ 0 ] );
						var prevMatch:String = String( longestResultByIndex[ result.index ][ 0 ] ); 					
						if ( currentMatch.length < prevMatch.length ) // we are shorter
						{
							continue;
						}
 						else if (  currentMatch.length == prevMatch.length  ) // tie... who wins?
						{
							if ( hasPrecedenceOver.getItemIndex( longestResultByIndex[ result.index ].regExp ) == -1 ) // we can't resolve the tie
							{
								continue; // current has no declared precedence over prev, so we just skip 
							}
						
						} 
					}


					longestResultByIndex[ result.index ] = result;
					
				}

				// we won't mess up someone else's day... 
				regExp.lastIndex = originalLastIndex;					
				
			}
			
			
			
			
			var results:Array = [];
			for ( var i:int=0; i<str.length; )
			{
				if ( longestResultByIndex[ i ] )
				{
					var res:Object = longestResultByIndex[ i ];
					results.push( res );
					 			
					// advance to the end of this match
					// we skip any matches in between ( we are disjoint, remember ) 			
					i += String( res[ 0 ] ).length;
				}
				else
				{
					// move to the next index and see if we found something
					i++;
				}				
			}

		
			return results;
		}
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * will calculate the pattern group to which the char at the given index belongs.
		 * If it is outside any pattern group, will return -1
		 * 
		 * This is non-trivial because we need to distinguish between parens that demark pattern groups
		 * and others that may be escaped or within character classes.
		 * 
		 * The passed in string must be a valid ECMAScript regular expression string. It can be in expanded mode.
		 * 
		 * @return 
		 * 
		 */		
		public static function getPatternGroupNumberAtIndex( regExpString:String, index:int ):int
		{
		
								
			
			
			
		
			return -1;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * 
		 * @param str
		 * @return 
		 * 
		 * @see http://simonwillison.net/2006/Jan/20/escape/
		 * 
		 */
		public static function escapeSpecialRegExpChars( str:String ):String
		{
			return str.replace( getSpecialCharsRegExp(), '\\$1' );
		}
		


		
		
		/**
		 * 
		 * we serve this as singleton to avoid compiling it over and over again
		 * 
		 * @return 
		 * 
		 */		
		private static function getSpecialCharsRegExp():RegExp
		{
			if ( ! scr )
				scr = new RegExp( '(\\' + specials.join('|\\') + ')', 'g' );		
			return scr;
		}
		// chars that need to be escaped when escaping a regexp
		private static var specials:Array = [ '/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\', '^' ];
		private static var scr:RegExp;
		
	}
	
}