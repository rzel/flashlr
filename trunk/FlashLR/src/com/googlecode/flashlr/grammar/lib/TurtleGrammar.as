package com.googlecode.flashlr.grammar.lib
{
	
	import com.googlecode.flashlr.grammar.Grammar;
	
	
	/**
	 * 
	 * 
	 * NOT FINISHED
	 * 
	 * 
	 * http://www.dajobe.org/2004/01/turtle/#sec-grammar
	 * 
	 * 
	 *
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class TurtleGrammar
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
	


//[1]	turtleDoc 	::= 	statement*
g.nt( "turtleDoc",
		"statement*"
 );
 
//[2]	statement 	::= 	directive ws* '.' ws* | triples ws* '.' ws* | ws+
g.nt( "statement",
		"directive ws* '.' ws* | triples ws* '.' ws* | ws+"
 );
 
//[3]	directive 	::= 	prefixID | base
g.nt( "directive",
		"prefixID | base"
 );
 
//[4]	prefixID 	::= 	'@prefix' ws+ prefixName? ':' ws+ uriref
g.nt( "prefixID",
		"'@prefix' ws+ prefixName? ':' ws+ uriref"
 );
 
//[5]	base 	::= 	'@base' ws+ uriref
g.nt( "base",
		"'@base' ws+ uriref"
 );
 
//[6]	triples 	::= 	subject ws+ predicateObjectList
//      Provides RDF triples using the given subject and each pair from the predicateObjectList
g.nt( "triples",
		"subject ws+ predicateObjectList"
 );
 
//[7]	predicateObjectList 	::= 	verb ws+ objectList ( ws* ';' ws* verb ws+ objectList )* (ws* ';')?
//      Provides a sequence of (verb, object) pairs for each object from the objectList
g.nt( "predicateObjectList",
		"verb ws+ objectList ( ws* ';' ws* verb ws+ objectList )* (ws* ';')?"
 );
 
//[8]	objectList 	::= 	object (ws* ',' ws* object)*
//      Provides a sequence of objects
g.nt( "objectList",
		"object (ws* ',' ws* object)*"
 );
 
//[9]	verb 	::= 	predicate | 'a'
//      where 'a' is equivalent to the uriref <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>
g.nt( "verb",
		"predicate | 'a'"
 );
 
//[10]	comment 	::= 	'#' ( [^#xA#xD] )*
g.t( "comment",
		" '#' ( [^\u000A\u000D] )* "
 );
 
//[11]	subject 	::= 	resource | blank
g.nt( "subject",
		"resource | blank"
 );
 
//[12]	predicate 	::= 	resource
g.nt( "predicate",
		"resource"
 );
 
//[13]	object 	::= 	resource | blank | literal
g.nt( "object",
		"resource | blank | literal"
 );
 
//[14]	literal 	::= 	quotedString ( '@' language )? | datatypeString | integer | double | decimal | boolean
g.nt( "literal",
		" quotedString ( '@' language )? | datatypeString | integer | double | decimal | boolean "
 );
 
//[15]	datatypeString 	::= 	quotedString '^^' resource
g.nt( "datatypeString",
		" quotedString '^^' resource "
 );
 
//[16]	integer 	::= 	('-' | '+') ? [0-9]+
//      Interpreted as an xsd:integer and generates a datatyped literal with 
//       the datatype uriref http://www.w3.org/2001/XMLSchema#integer and canonical 
//       lexical representation of xsd:integer which includes allowing no leading zeros.
g.t( "integer",
		" ('-' | '+')? [0-9]+ "
 );
 
 
//[17]	double 	::= 	('-' | '+') ? ( [0-9]+ '.' [0-9]* exponent | '.' ([0-9])+ exponent | ([0-9])+ exponent )
//      Interpreted as an xsd:double and generates a datatyped literal 
//      with the datatype uriref http://www.w3.org/2001/XMLSchema#double and any legal lexical representation of xsd:double.
g.t( "double",
		"   [-+]? ( [0-9]+ \\. [0-9]* {{exponent}} | \\. ([0-9])+ {{exponent}} | ([0-9])+ {{exponent}} )"
 );
 
//[18]	decimal 	::= 	('-' | '+')? ( [0-9]+ '.' [0-9]* | '.' ([0-9])+ | ([0-9])+ )
//		Interpreted as an xsd:decimal and generates a datatyped literal with the datatype 
//        uriref http://www.w3.org/2001/XMLSchema#decimal and any legal lexical representation of xsd:decimal.
g.t( "decimal",
		"  [-+]? ( [0-9]+ \\. [0-9]* | \\. ([0-9])+ | ([0-9])+ )"
 );
 
//[19]	exponent 	::= 	[eE] ('-' | '+')? [0-9]+
g.t( "exponent",
		"  [eE] [-+]? [0-9]+ "
 );
 
//[20]	boolean 	::= 	'true' | 'false'
//       Interpreted as an xsd:boolean and generates a datatyped literal with the datatype 
//         uriref http://www.w3.org/2001/XMLSchema#boolean and canonical lexical representation of xsd:boolean.
g.nt( "boolean",
		"  'true' | 'false'  "
 );
 
//[21]	blank 	::= 	nodeID | '[]' | '[' ws* predicateObjectList ws* ']' | collection
//       Provides a blank node either from the given nodeID, a generated one, 
//        a generated one which is also used to provide the subject of RDF triples 
//        for each pair from the predicateObjectList or the root of the collection.
g.nt( "blank",
		"  nodeID | '[]' | '[' ws* predicateObjectList ws* ']' | collection  "
 );
 
//[22]	itemList 	::= 	object (ws+ object)*
//        Provides a sequence of objects (Note there are no commas between items unlike objectList)
g.nt( "itemList",
		"  object ( ws+ object )*  "
 );
 
//[23]	collection 	::= 	'(' ws* itemList? ws* ')'
//        Provides a blank node at the start of an RDF collection of the objects
//        in the itemList. See section Collections for the triples generated.
g.nt( "collection",
		"  '(' ws* itemList? ws* ')'  "
 );
 
//[24]	ws 	::= 	#x9 | #xA | #xD | #x20 | comment
g.t( "ws",
		"  [\u0009\u000A\u000D\u0020] | {{comment}}  "
 );
 
//[25]	resource 	::= 	uriref | qname
g.nt( "resource",
		"  uriref | qname  "
 );
 
//[26]	nodeID 	::= 	'_:' name
g.nt( " nodeID ",
		"  '_:' name  "
 );
 
//[27]	qname 	::= 	prefixName? ':' name?
//       See section QNames
g.nt( "qname",
		"  prefixName? ':' name?  "
 );
 
//[28]	uriref 	::= 	'<' relativeURI '>'
g.nt( "uriref",
		" '<' relativeURI '>' "
 );
 
//[29]	language 	::= 	[a-z]+ ('-' [a-z0-9]+ )*
//        encoding a language tag.
g.t( "language",
		"  [a-z]+ ( - [a-z0-9]+ )*  "
 );
 
//[30]	nameStartChar 	::= 	[A-Z] | "_" | [a-z] | [#x00C0-#x00D6] | [#x00D8-#x00F6] | [#x00F8-#x02FF] | [#x0370-#x037D] | [#x037F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
g.t( "nameStartChar",
		"[A-Za-z_] | [\u00C0-\u00D6] | [\u00D8-\u00F6] | [\u00F8-\u02FF] | [\u0370-\u037D] | [\u037F-\u1FFF] | [\u200C-\u200D] | [\u2070-\u218F] | [\u2C00-\u2FEF] | [\u3001-\uD7FF] | [\uF900-\uFDCF] | [\uFDF0-\uFFFD] "
 );
 
//[31]	nameChar 	::= 	nameStartChar | '-' | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040]
g.t( "nameChar",
		" {{nameStartChar}} | - | [0-9] | \u00B7 | [\u0300-\u036F] | [\u203F-\u2040]  "
 );
 
//[32]	name 	::= 	nameStartChar nameChar*
g.t( "name",
		"  {{nameStartChar}} {{nameChar}}*  "
 );
 
//[33]	prefixName 	::= 	( nameStartChar - '_' ) nameChar*
//         WARNING:  WE ARE ACCEPTING PREFIXES STARTING WITH UNDERSCORE
g.t( "prefixName",
		"  {{nameStartChar}} {{nameChar}}*  "
 );
 
//[34]	relativeURI 	::= 	ucharacter*
//       Used as a relative URI and resolved against the current base URI to give an absolute URI reference.
g.t( "relativeURI",
		"  {{ucharacter}}*  "
 );
 
//[35]	quotedString 	::= 	string | longString
g.nt( "quotedString",
		" string | longString "
 );
 
//[36]	string 	::= 	#x22 scharacter* #x22
g.t( "string",
		' " {{scharacter}}* " '
 );
 
//[37]	longString 	::= 	#x22 #x22 #x22 lcharacter* #x22 #x22 #x22
g.t( "longString",
		'  """ {{lcharacter}}* """     '
 );
 
//[38]	character 	::= 	'\u' hex hex hex hex |
//                          '\U' hex hex hex hex hex hex hex hex |
//                          '\\' |
//                          [#x20-#x5B] | [#x5D-#x10FFFF]
//        See String Escapes for full details.
g.t( "character",
		" \\ [uU] {{hex}}{4,8}   "
 );
 
//[39]	echaracter 	::= 	character | '\t' | '\n' | '\r'
//                  See String Escapes for full details.
g.t( "echaracter",
		" {{character}} | \\t | \\n | \\r "
 );
 
//[40]	hex 	::= 	[#x30-#x39] | [#x41-#x46]
//           hexadecimal digit (0-9, uppercase A-F)
g.t( "hex",
		" [0-9A-F] "
 );
 
//[41]	ucharacter 	::= 	( character - #x3E ) | '\>'
g.t( "",
		""
 );
 
//[42]	scharacter 	::= 	( echaracter - #x22 ) | '\"'
g.t( "",
		""
 );
 
//[43]	lcharacter 	::= 	echaracter | '\"' | #x9 | #xA | #xD 
g.t( "",
		""
 );
	
	
	
		}
	
		
	}
	
}

