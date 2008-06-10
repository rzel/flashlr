package com.googlecode.flashlr.grammar.lib
{
	import com.googlecode.flashlr.grammar.Grammar;
	
	
	/**
	 * 
	 * NOT FINISHED
	 * 
	 * @author aleyton
	 * 
	 */
	public class NTripleGrammar
	{
		private static var grammar:Grammar;
		
		
		public static function getGrammar():Grammar
		{
			if ( !grammar )
				build();
			return grammar;
		}


		private static function build():void
		{
		
			var g:Grammar = grammar = new Grammar(  );	

	//[1]	ntripleDoc  	::=  	line*
	g.nt( "ntripleDoc",
			"line*"
	 );
	 //[2]	line  	::=  	ws* ( comment | triple )? eoln
	g.nt( "line",
			"ws* ( comment | triple )? eoln"
	 );
	 //[3]	comment  	::=  	'#' ( character - ( cr | lf ) )*
	g.nt( "comment",
			"'#' ( character - ( cr | lf ) )*"
	 );
	 //[4]	triple  	::=  	subject ws+ predicate ws+ object ws* '.' ws*
	g.nt( "triple",
			"subject ws+ predicate ws+ object ws* '.' ws*"
	 );
	 //[5]	subject  	::=  	uriref | nodeID
	g.nt( "subject",
			"uriref | nodeID"
	 );
	 //[6]	predicate  	::=  	uriref
	g.nt( "predicate",
			"uriref"
	 );
	 //[7]	object  	::=  	uriref | nodeID | literal
	g.nt( "object",
			"uriref | nodeID | literal"
	 );
	 //[8]	uriref  	::=  	'<' absoluteURI '>'
	g.nt( "uriref",
			"'<' absoluteURI '>'"
	 );
	 //[9]	nodeID  	::=  	'_:' name
	g.nt( "nodeID",
			"'_:' name"
	 );
	 //[10]	literal  	::=  	langString | datatypeString
	g.nt( "literal",
			"langString | datatypeString"
	 );
	 //[11]	langString  	::=  	'"' string '"' ( '@' language )?
	g.nt( "langString",
			"'\"' string '\"' ( '@' language )?"
	 );
	 //[12]	datatypeString  	::=  	'"' string '"' '^^' uriref
	g.nt( "datatypeString",
			"'\"' string '\"' '^^' uriref"
	 );
	 //[13]	language  	::=  	[a-z]+ ('-' [a-z0-9]+ )*
	g.nt( "language",
			"[a-z]+ ('-' [a-z0-9]+ )*"
	 );
	 //[14]	ws  	::=  	space | tab
	g.nt( "ws",
			"space | tab"
	 );
	 //[15]	eoln  	::=  	cr | lf | cr lf
	g.nt( "eoln",
			"cr | lf | cr lf"
	 );
	 //[16]	space  	::=  	#x20 /* US-ASCII space - decimal 32 */
	g.nt( "space",
			"#x20"
	 );
	 //[17]	cr  	::=  	#xD /* US-ASCII carriage return - decimal 13 */  	 
	g.nt( "cr",
			"#xD"
	 );
	 //[18]	lf  	::=  	#xA /* US-ASCII line feed - decimal 10 */
	g.nt( "lf",
			"#xA"
	 );
	 //[19]	tab  	::=  	#x9 /* US-ASCII horizontal tab - decimal 9 */  
	g.nt( "tab",
			"#x9"
	 );
	 //[20]	string  	::=  	character* with escapes as defined in section Strings  	 
	g.nt( "string",
			"character*"
	 );
	 //[21]	name  	::=  	[A-Za-z][A-Za-z0-9]*
	g.nt( "name",
			"[A-Za-z][A-Za-z0-9]*"
	 );
	 //[22]	absoluteURI  	::=  	character+ with escapes as defined in section URI References  	 
	g.nt( "absoluteURI",
			"character+"
	 );
	 //[23]	character  	::=  	[#x20-#x7E] /* US-ASCII space to decimal 126 */
	g.nt( "character",
			"[#x20-#x7E]"
	 );
	
	
		}
	
		
	}
	
}

