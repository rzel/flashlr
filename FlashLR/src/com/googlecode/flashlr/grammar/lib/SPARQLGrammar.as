package com.googlecode.flashlr.grammar.lib
{
	
	import com.googlecode.flashlr.grammar.Grammar;
	
	
	/**
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class SPARQLGrammar
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



// [1]     Query     ::=       Prologue ( SelectQuery | ConstructQuery | DescribeQuery | AskQuery )
g.nt( "Query" ,
	"Prologue ( SelectQuery | ConstructQuery | DescribeQuery | AskQuery ) "
	 );


// [2]     Prologue      ::=       BaseDecl? PrefixDecl*
g.nt( "Prologue" ,
	"BaseDecl? PrefixDecl*"
	 );


// [3]     BaseDecl      ::=       'BASE' IRI_REF
g.nt( "BaseDecl" ,
	"'BASE' IRI_REF"
	 );


// [4]     PrefixDecl    ::=       'PREFIX' PNAME_NS IRI_REF
g.nt( "PrefixDecl" ,
	"'PREFIX' PNAME_NS IRI_REF"
	 );


// [5]     SelectQuery       ::=       'SELECT' ( 'DISTINCT' | 'REDUCED' )? ( Var+ | '*' ) DatasetClause* WhereClause SolutionModifier
g.nt( "SelectQuery" ,
	"'SELECT' ( 'DISTINCT' | 'REDUCED' )? ( Var+ | '*' ) DatasetClause* WhereClause SolutionModifier"
	 );


// [6]     ConstructQuery    ::=       'CONSTRUCT' ConstructTemplate DatasetClause* WhereClause SolutionModifier
g.nt( "ConstructQuery" ,
	"'CONSTRUCT' ConstructTemplate DatasetClause* WhereClause SolutionModifier"
	 );


// [7]     DescribeQuery     ::=       'DESCRIBE' ( VarOrIRIref+ | '*' ) DatasetClause* WhereClause? SolutionModifier
g.nt( "DescribeQuery" ,
	"'DESCRIBE' ( VarOrIRIref+ | '*' ) DatasetClause* WhereClause? SolutionModifier"
	 );


// [8]     AskQuery      ::=       'ASK' DatasetClause* WhereClause
g.nt( "AskQuery" ,
	"'ASK' DatasetClause* WhereClause"
	 );


// [9]     DatasetClause     ::=       'FROM' ( DefaultGraphClause | NamedGraphClause )
g.nt( "DatasetClause" ,
	"'FROM' ( DefaultGraphClause | NamedGraphClause )"
	 );


// [10]    DefaultGraphClause    ::=       SourceSelector
g.nt( "DefaultGraphClause" ,
	"SourceSelector"
	 );


// [11]    NamedGraphClause      ::=       'NAMED' SourceSelector
g.nt( "NamedGraphClause" ,
	"'NAMED' SourceSelector"
	 );


// [12]    SourceSelector    ::=       IRIref
g.nt( "SourceSelector" ,
	"IRIref"
	 );


// [13]    WhereClause       ::=       'WHERE'? GroupGraphPattern
g.nt( "WhereClause" ,
	"'WHERE'? GroupGraphPattern"
	 );


// [14]    SolutionModifier      ::=       OrderClause? LimitOffsetClauses?
g.nt( "SolutionModifier" ,
	"OrderClause? LimitOffsetClauses?"
	 );


// [15]    LimitOffsetClauses    ::=       ( LimitClause OffsetClause? | OffsetClause LimitClause? )
g.nt( "LimitOffsetClauses" ,
	"( LimitClause OffsetClause? | OffsetClause LimitClause? )"
	 );


// [16]    OrderClause       ::=       'ORDER' 'BY' OrderCondition+
g.nt( "OrderClause" ,
	"'ORDER' 'BY' OrderCondition+"
	 );


// [17]    OrderCondition    ::=       ( ( 'ASC' | 'DESC' ) BrackettedExpression ) | ( Constraint | Var )
g.nt( "OrderCondition" ,
	"( ( 'ASC' | 'DESC' ) BrackettedExpression ) | ( Constraint | Var )"
	 );


// [18]    LimitClause       ::=       'LIMIT' INTEGER
g.nt( "LimitClause" ,
	"'LIMIT' INTEGER"
	 );


// [19]    OffsetClause      ::=       'OFFSET' INTEGER
g.nt( "OffsetClause" ,
	"'OFFSET' INTEGER"
	 );


// [20]    GroupGraphPattern     ::=       '{' TriplesBlock? ( ( GraphPatternNotTriples | Filter ) '.'? TriplesBlock? )* '}'
g.nt( "GroupGraphPattern" ,
	"'{' TriplesBlock? ( ( GraphPatternNotTriples | Filter ) '.'? TriplesBlock? )* '}'"
	 );


// [21]    TriplesBlock      ::=       TriplesSameSubject ( '.' TriplesBlock? )?
g.nt( "TriplesBlock" ,
	"TriplesSameSubject ( '.' TriplesBlock? )?"
	 );


// [22]    GraphPatternNotTriples    ::=       OptionalGraphPattern | GroupOrUnionGraphPattern | GraphGraphPattern
g.nt( "GraphPatternNotTriples" ,
	"OptionalGraphPattern | GroupOrUnionGraphPattern | GraphGraphPattern"
	 );


// [23]    OptionalGraphPattern      ::=       'OPTIONAL' GroupGraphPattern
g.nt( "OptionalGraphPattern" ,
	"'OPTIONAL' GroupGraphPattern"
	 );


// [24]    GraphGraphPattern     ::=       'GRAPH' VarOrIRIref GroupGraphPattern
g.nt( "GraphGraphPattern" ,
	"'GRAPH' VarOrIRIref GroupGraphPattern"
	 );


// [25]    GroupOrUnionGraphPattern      ::=       GroupGraphPattern ( 'UNION' GroupGraphPattern )*
g.nt( "GroupOrUnionGraphPattern" ,
	"GroupGraphPattern ( 'UNION' GroupGraphPattern )*"
	 );


// [26]    Filter    ::=       'FILTER' Constraint
g.nt( "Filter" ,
	"'FILTER' Constraint"
	 );


// [27]    Constraint    ::=       BrackettedExpression | BuiltInCall | FunctionCall
g.nt( "Constraint" ,
	"BrackettedExpression | BuiltInCall | FunctionCall"
	 );


// [28]    FunctionCall      ::=       IRIref ArgList
g.nt( "FunctionCall" ,
	"IRIref ArgList"
	 );


// [29]    ArgList       ::=       ( NIL | '(' Expression ( ',' Expression )* ')' )
g.nt( "ArgList" ,
	"( NIL | '(' Expression ( ',' Expression )* ')' )"
	 );


// [30]    ConstructTemplate     ::=       '{' ConstructTriples? '}'
g.nt( "ConstructTemplate" ,
	"'{' ConstructTriples? '}'"
	 );


// [31]    ConstructTriples      ::=       TriplesSameSubject ( '.' ConstructTriples? )?
g.nt( "ConstructTriples" ,
	"TriplesSameSubject ( '.' ConstructTriples? )?"
	 );


// [32]    TriplesSameSubject    ::=       VarOrTerm PropertyListNotEmpty | TriplesNode PropertyList
g.nt( "TriplesSameSubject" ,
	"VarOrTerm PropertyListNotEmpty | TriplesNode PropertyList"
	 );


// [33]    PropertyListNotEmpty      ::=       Verb ObjectList ( ';' ( Verb ObjectList )? )*
g.nt( "PropertyListNotEmpty" ,
	"Verb ObjectList ( ';' ( Verb ObjectList )? )*"
	 );


// [34]    PropertyList      ::=       PropertyListNotEmpty?
g.nt( "PropertyList" ,
	"PropertyListNotEmpty?"
	 );


// [35]    ObjectList    ::=       Object ( ',' Object )*
g.nt( "ObjectList" ,
	"Object ( ',' Object )*"
	 );


// [36]    Object    ::=       GraphNode
g.nt( "Object" ,
	"GraphNode"
	 );


// [37]    Verb      ::=       VarOrIRIref | 'a'
g.nt( "Verb" ,
	"VarOrIRIref | 'a'"
	 );


// [38]    TriplesNode       ::=       Collection | BlankNodePropertyList
g.nt( "TriplesNode" ,
	"Collection | BlankNodePropertyList"
	 );


// [39]    BlankNodePropertyList     ::=       '[' PropertyListNotEmpty ']'
g.nt( "BlankNodePropertyList" ,
	"'[' PropertyListNotEmpty ']'"
	 );


// [40]    Collection    ::=       '(' GraphNode+ ')'
g.nt( "Collection" ,
	"'(' GraphNode+ ')'"
	 );


// [41]    GraphNode     ::=       VarOrTerm | TriplesNode
g.nt( "GraphNode" ,
	"VarOrTerm | TriplesNode"
	 );


// [42]    VarOrTerm     ::=       Var | GraphTerm
g.nt( "VarOrTerm" ,
	"Var | GraphTerm"
	 );


// [43]    VarOrIRIref       ::=       Var | IRIref
g.nt( "VarOrIRIref" ,
	"Var | IRIref"
	 );


// [44]    Var       ::=       VAR1 | VAR2
g.nt( "Var" ,
	"VAR1 | VAR2"
	 );

// [45]    GraphTerm     ::=       IRIref | RDFLiteral | NumericLiteral | BooleanLiteral | BlankNode | NIL
g.nt( "GraphTerm" ,
	"IRIref | RDFLiteral | NumericLiteral | BooleanLiteral | BlankNode | NIL"
	 );


// [46]    Expression    ::=       ConditionalOrExpression
g.nt( "Expression" ,
	"ConditionalOrExpression"
	 );


// [47]    ConditionalOrExpression       ::=       ConditionalAndExpression ( '||' ConditionalAndExpression )*
g.nt( "ConditionalOrExpression" ,
	"ConditionalAndExpression ( '||' ConditionalAndExpression )*"
	 );


// [48]    ConditionalAndExpression      ::=       ValueLogical ( '&&' ValueLogical )*
g.nt( "ConditionalAndExpression" ,
	"ValueLogical ( '&&' ValueLogical )*"
	 );


// [49]    ValueLogical      ::=       RelationalExpression
g.nt( "ValueLogical" ,
	"RelationalExpression"
	 );


// [50]    RelationalExpression      ::=       NumericExpression ( '=' NumericExpression | '!=' NumericExpression | '<' NumericExpression | '>' NumericExpression | '<=' NumericExpression | '>=' NumericExpression )?
g.nt( "RelationalExpression" ,
	"NumericExpression ( '=' NumericExpression | '!=' NumericExpression | '<' NumericExpression | '>' NumericExpression | '<=' NumericExpression | '>=' NumericExpression )?"
	 );


// [51]    NumericExpression     ::=       AdditiveExpression
g.nt( "NumericExpression" ,
	"AdditiveExpression"
	 );


// [52]    AdditiveExpression    ::=       MultiplicativeExpression ( '+' MultiplicativeExpression | '-' MultiplicativeExpression | NumericLiteralPositive | NumericLiteralNegative )*
g.nt( "AdditiveExpression" ,
	"MultiplicativeExpression ( '+' MultiplicativeExpression | '-' MultiplicativeExpression | NumericLiteralPositive | NumericLiteralNegative )*"
	 );


// [53]    MultiplicativeExpression      ::=       UnaryExpression ( '*' UnaryExpression | '/' UnaryExpression )*
g.nt( "MultiplicativeExpression" ,
	"UnaryExpression ( '*' UnaryExpression | '/' UnaryExpression )*"
	 );


// [54]    UnaryExpression       ::=         '!' PrimaryExpression | '+' PrimaryExpression | '-' PrimaryExpression | PrimaryExpression
g.nt( "UnaryExpression" ,
	"'!' PrimaryExpression | '+' PrimaryExpression | '-' PrimaryExpression | PrimaryExpression"
	 );


// [55]    PrimaryExpression     ::=       BrackettedExpression | BuiltInCall | IRIrefOrFunction | RDFLiteral | NumericLiteral | BooleanLiteral | Var
g.nt( "PrimaryExpression" ,
	"BrackettedExpression | BuiltInCall | IRIrefOrFunction | RDFLiteral | NumericLiteral | BooleanLiteral | Var"
	 );


// [56]    BrackettedExpression      ::=       '(' Expression ')'
g.nt( "BrackettedExpression" ,
	"'(' Expression ')'"
	 );


// [57]    BuiltInCall       ::=         'STR' '(' Expression ')' | 'LANG' '(' Expression ')' | 'LANGMATCHES' '(' Expression ',' Expression ')' | 'DATATYPE' '(' Expression ')' | 'BOUND' '(' Var ')' | 'sameTerm' '(' Expression ',' Expression ')' | 'isIRI' '(' Expression ')' | 'isURI' '(' Expression ')' | 'isBLANK' '(' Expression ')' | 'isLITERAL' '(' Expression ')' | RegexExpression
g.nt( "BuiltInCall" ,
	"'STR' '(' Expression ')' | 'LANG' '(' Expression ')' | 'LANGMATCHES' '(' Expression ',' Expression ')' | 'DATATYPE' '(' Expression ')' | 'BOUND' '(' Var ')' | 'sameTerm' '(' Expression ',' Expression ')' | 'isIRI' '(' Expression ')' | 'isURI' '(' Expression ')' | 'isBLANK' '(' Expression ')' | 'isLITERAL' '(' Expression ')' | RegexExpression"
	 );


// [58]    RegexExpression       ::=       'REGEX' '(' Expression ',' Expression ( ',' Expression )? ')'
g.nt( "RegexExpression" ,
	"'REGEX' '(' Expression ',' Expression ( ',' Expression )? ')'"
	 );


// [59]    IRIrefOrFunction      ::=       IRIref ArgList?
g.nt( "IRIrefOrFunction" ,
	"IRIref ArgList?"
	 );


// [60]    RDFLiteral    ::=       String ( LANGTAG | ( '^^' IRIref ) )?
g.nt( "RDFLiteral" ,
	"String ( LANGTAG | ( '^^' IRIref ) )?"
	 );


// [61]    NumericLiteral    ::=       NumericLiteralUnsigned | NumericLiteralPositive | NumericLiteralNegative
g.nt( "NumericLiteral" ,
	"NumericLiteralUnsigned | NumericLiteralPositive | NumericLiteralNegative"
	 );


// [62]    NumericLiteralUnsigned    ::=       INTEGER | DECIMAL | DOUBLE
g.nt( "NumericLiteralUnsigned" ,
	"INTEGER | DECIMAL | DOUBLE"
	 );


// [63]    NumericLiteralPositive    ::=       INTEGER_POSITIVE | DECIMAL_POSITIVE | DOUBLE_POSITIVE
g.nt( "NumericLiteralPositive" ,
	"INTEGER_POSITIVE | DECIMAL_POSITIVE | DOUBLE_POSITIVE"
	 );


// [64]    NumericLiteralNegative    ::=       INTEGER_NEGATIVE | DECIMAL_NEGATIVE | DOUBLE_NEGATIVE
g.nt( "NumericLiteralNegative" ,
	"INTEGER_NEGATIVE | DECIMAL_NEGATIVE | DOUBLE_NEGATIVE"
	 );


// [65]    BooleanLiteral    ::=       'true' | 'false'
g.nt( "BooleanLiteral" ,
	"'true' | 'false'"
	 );


// [66]    String    ::=       STRING_LITERAL1 | STRING_LITERAL2 | STRING_LITERAL_LONG1 | STRING_LITERAL_LONG2
g.nt( "String" ,
	"STRING_LITERAL1 | STRING_LITERAL2 | STRING_LITERAL_LONG1 | STRING_LITERAL_LONG2"
	 );


// [67]    IRIref    ::=       IRI_REF | PrefixedName
g.nt( "IRIref" ,
	"IRI_REF | PrefixedName"
	 );


// [68]    PrefixedName      ::=       PNAME_LN | PNAME_NS
g.nt( "PrefixedName" ,
	"PNAME_LN | PNAME_NS"
	 );


// [69]    BlankNode     ::=       BLANK_NODE_LABEL | ANON
g.nt( "BlankNode" ,
	"BLANK_NODE_LABEL | ANON"
	 );



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// terminals ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// [70]    IRI_REF       ::=       '<' ([^<>"{}|^`\]-[#x00-#x20])* '>'
g.t( "IRI_REF" ,
	"   <  (  [^<>\"{}|^`\u0001-\u0020]  )  *  >  "
//	"   <  (  [^<>\"{}|^`\u0000-\u0020]  )  *  >  "
	 );

 
// [71]    PNAME_NS      ::=       PN_PREFIX? ':'
g.t( "PNAME_NS" ,
	"  {{PN_PREFIX}} ? : "
	 );


// [72]    PNAME_LN      ::=       PNAME_NS PN_LOCAL
g.t( "PNAME_LN" ,
	"  {{PNAME_NS}} {{PN_LOCAL}}  "
	 );


// [73]    BLANK_NODE_LABEL      ::=       '_:' PN_LOCAL
g.t( "BLANK_NODE_LABEL" ,
	"  _: {{PN_LOCAL}}  "
	 );


// [74]    VAR1      ::=       '?' VARNAME
g.t( "VAR1" ,
	"   \\? {{VARNAME}}  "
	 );


// [75]    VAR2      ::=       '$' VARNAME
g.t( "VAR2" ,
	"   \\$ {{VARNAME}}  "
	 );


// [76]    LANGTAG       ::=       '@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
g.t( "LANGTAG" ,
	"  @ [a-zA-Z]+ ( - [a-zA-Z0-9]+ ) *  "
	 );


// [77]    INTEGER       ::=       [0-9]+
g.t( "INTEGER" ,
	"  [0-9]+  "
	 );


// [78]    DECIMAL       ::=       [0-9]+ '.' [0-9]* | '.' [0-9]+
g.t( "DECIMAL" ,
	"  ( [0-9]+ \\. [0-9]* ) | ( \\. [0-9]+ ) "
	 );


// [79]    DOUBLE    ::=       [0-9]+ '.' [0-9]* EXPONENT | '.' ([0-9])+ EXPONENT | ([0-9])+ EXPONENT
g.t( "DOUBLE" ,
	"  [0-9]+ \\. [0-9]* {{EXPONENT}} | \\. ([0-9])+ {{EXPONENT}} | ([0-9])+ {{EXPONENT}} "
	 );


// [80]    INTEGER_POSITIVE      ::=       '+' INTEGER
g.t( "INTEGER_POSITIVE" ,
	"  \\+ {{INTEGER}} "
	 );


// [81]    DECIMAL_POSITIVE      ::=       '+' DECIMAL
g.t( "DECIMAL_POSITIVE" ,
	"  \\+  {{DECIMAL}} "
	 );


// [82]    DOUBLE_POSITIVE       ::=       '+' DOUBLE
g.t( "DOUBLE_POSITIVE" ,
	"  \\+  {{DOUBLE}} "
	 );


// [83]    INTEGER_NEGATIVE      ::=       '-' INTEGER
g.t( "INTEGER_NEGATIVE" ,
	" - {{INTEGER}} "
	 );


// [84]    DECIMAL_NEGATIVE      ::=       '-' DECIMAL
g.t( "DECIMAL_NEGATIVE" ,
	" - {{DECIMAL}} "
	 );


// [85]    DOUBLE_NEGATIVE       ::=       '-' DOUBLE
g.t( "DOUBLE_NEGATIVE" ,
	"  -  {{DOUBLE}} "
	 );


// [86]    EXPONENT      ::=       [eE] [+-]? [0-9]+
g.t( "EXPONENT" ,
	" [eE] [+-]? [0-9]+ "
	 );


// [87]    STRING_LITERAL1       ::=       "'" ( ([^#x27#x5C#xA#xD]) | ECHAR )* "'"
g.t( "STRING_LITERAL1" ,
	"  '   ( ( [^\u0027\u005C\u000A\u000D] ) | {{ECHAR}} ) *?   '    "
	 );


// [88]    STRING_LITERAL2       ::=       '"' ( ([^#x22#x5C#xA#xD]) | ECHAR )* '"'
g.t( "STRING_LITERAL2" ,
	'  " ( ([^\u0022\u005C\u000A\u000D]) | {{ECHAR}} ) *?    "   '
	 );


// [89]    STRING_LITERAL_LONG1      ::=       "'''" ( ( "'" | "''" )? ( [^'\] | ECHAR ) )* "'''"
g.t( "STRING_LITERAL_LONG1" ,
	"   '''  ( ( ' | '' )? ( [^'\\] | {{ECHAR}} ) ) *?   '''     "
	 );


// [90]    STRING_LITERAL_LONG2      ::=       '"""' ( ( '"' | '""' )? ( [^"\] | ECHAR ) )* '"""'
g.t( "STRING_LITERAL_LONG2" ,
	'    """ ( ( " | "" )? ( [^"\\]  |  {{ECHAR}}  ) ) *?    """     '
	 );


// [91]    ECHAR     ::=       '\' [tbnrf\"']
// stands for Escaped CHAR
g.t( "ECHAR" ,
	" \\\\ [tbnrf\"']  "
//	"  \\\\ [tbnrf\"']  "
	 );


// [92]    NIL       ::=       '(' WS* ')'
g.t( "NIL" ,
	"  \\(  {{WS}}* \\)   "
	 );


// [93]    WS    ::=       #x20 | #x9 | #xD | #xA
g.t( "WS" ,
	" [\u0020\u0009\u000D\u000A] "
	 );


// [94]    ANON      ::=       '[' WS* ']'
g.t( "ANON" ,
	"  \\[ {{WS}}* \\]  "
	 );


// [95]    PN_CHARS_BASE     ::=       [A-Z] | [a-z] | [#x00C0-#x00D6] | [#x00D8-#x00F6] | [#x00F8-#x02FF] | [#x0370-#x037D] | [#x037F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
g.t( "PN_CHARS_BASE" ,
	" [A-Za-z] "
	// " [ A-Z a-z \u00C0-\u00D6 \u00D8-\u00F6 \u00F8-\u02FF \u0370-\u037D \u037F-\u1FFF \u200C-\u200D \u2070-\u218F \u2C00-\u2FEF \u3001-\uD7FF \uF900-\uFDCF \uFDF0-\uFFFD ]"
	//" [A-Z] | [a-z] | [\u00C0-\u00D6] | [\u00D8-\u00F6] | [\u00F8-\u02FF] | [\u0370-\u037D] | [\u037F-\u1FFF] | [\u200C-\u200D] | [\u2070-\u218F] | [\u2C00-\u2FEF] | [\u3001-\uD7FF] | [\uF900-\uFDCF] | [\uFDF0-\uFFFD] | [\u10000-\uEFFFF]"
	 );


// [96]    PN_CHARS_U    ::=       PN_CHARS_BASE | '_'
g.t( "PN_CHARS_U" ,
	"  {{PN_CHARS_BASE}} | _ "
	 );


// [97]    VARNAME       ::=       ( PN_CHARS_U | [0-9] ) ( PN_CHARS_U | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040] )*
g.t( "VARNAME" ,
	// "(  {{PN_CHARS_U}}  |  [0-9]  ) (  {{PN_CHARS_U}}  |  [0-9] | \u00B7 | [\u0300-\u036F] | [\u203F-\u2040] )*  "
	"(  {{PN_CHARS_U}} | [0-9] ) (  {{PN_CHARS_U}}  |  [0-9]  )*  "
	 );


// [98]    PN_CHARS      ::=       PN_CHARS_U | '-' | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040]
g.t( "PN_CHARS" ,
	//"  {{PN_CHARS_U}}  | - |  [0-9] | \u00B7 | [\u0300-\u036F] | [\u203F-\u2040]  "
	"  {{PN_CHARS_U}}  | - |  [0-9]  "
	 );


// [99]    PN_PREFIX     ::=       PN_CHARS_BASE ((PN_CHARS|'.')* PN_CHARS)?
g.t( "PN_PREFIX" ,
	"  {{PN_CHARS_BASE}}  ( ( {{PN_CHARS}}  |   \\.   )*  {{PN_CHARS}}   )? "
	 );


// [100]       PN_LOCAL      ::=       ( PN_CHARS_U | [0-9] ) ((PN_CHARS|'.')* PN_CHARS)?
g.t( "PN_LOCAL" ,
	"  ( {{PN_CHARS_U}} | [0-9] ) ( (  {{PN_CHARS}}   |  \\.  )*  {{PN_CHARS}}  )? "
	 );


////////////////////////////////////////////////////////////////
/////////////////////////// additions //////////////////////////
////////////////////////////////////////////////////////////////



// added comment ( aldo.bucchi@gmail.com )
g.t( "COMMENT" ,
	"  [#] [^\\n\\r]*? [\\n\\r] "
	 );

		
		g.init();

		
		
		}

	}
	
}