package com.googlecode.flashlr.grammar
{
	import com.googlecode.flashlr.utils.RegExpUtil;
	
	
	
	/**
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class NonTerminal extends Production
	{
		
		
		private var _expressionNoKeywords:String;
		public function get expressionNoKeywords():String
		{
			return _expressionNoKeywords;
		}
	
		
		public function NonTerminal( grammar:Grammar, name:String, expression:String )
		{
			
			super( grammar, name, expression );
			
		}
	


		internal function replaceKeywordsWithTerminals():void
		{
			_expressionNoKeywords = RegExpUtil.replaceDisjointWithCallback( [ str1, str2 ], expression, replaceKeywordsCallback );
		}
		
		
		
		private function replaceKeywordsCallback( result:Array ):String
		{
			return grammar.getOrCreateKeywordTerminal(  String( result[1] ) ).name;
		}
		
		
		
		private static var str1:RegExp = / ' ([^ ' ]*?) ' /gx;

		private static var str2:RegExp = / " ([^ " ]*?) " /gx;				
		
	
		
	}
	
	
}