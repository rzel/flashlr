package com.googlecode.flashlr.parser.model
{
	
	
	

	/**
	 * 
	 * This class is an auxilliary used during expression parsing to generate the ParseModel
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	internal class QuantifiedName 
	{
		
		
		public var name:String;
		
		public var min:int;
		
		public var max:int;
		

		public function get isExactlyOne( ):Boolean
		{
			
			return ( min==1 && max==1 );
		
		}



		public function QuantifiedName( name:String, min:int, max:int )
		{
		
			this.name = name;
			this.min = min;
			this.max = max;
		
		}
		
		
		
		
		public function toString(  ):String
		{
		
			return name + "{" + min + "," + max + "}";
		
		}
		
		
		
		
		
		

		
		/**
		 * 
		 * TODO: rename term-->name
		 * 
		 * @return 
		 * 
		 */		
		public static function parseSequence( expression:String ):Array
		{
		
		
			// replace all unary symbol quantifiers by curly brace quantifiers
			expression = expression.replace( /  \+ /xg, "{1,}"  );
			expression = expression.replace( /  \* /xg, "{0,}"  );
			expression = expression.replace( /  \? /xg, "{0,1}"  );
			
			// remove spaces to the left of every curly brace
			expression = expression.replace( /  \s*\{ /xg, "{"  );
			
			// and add an extra space to the right of every closing curly brace
			expression = expression.replace( /  \} /xg, "} "  );

			// add quantifiers to identifiers that don't have
			expression += " ";// add a space to the right so the following works OK for the last term
			expression = expression.replace( / (\w)\s /xg, "$1{1} "  );
						
			// remove whitespace
			expression = expression.replace( /  \s+ /xg, ""  );
			
			
			// we finished normalizing... split and analyze
			// we will create an array called terms with the name and the quantifier info
			// of each referenced production
			var names:Array = expression.split("}");
			
			names.pop(); // remove the last element, it is empty ( due to the way we split it )
			
			for ( var i:int = 0; i<names.length; i++ )
			{

				var arr:String = String( names[ i ] );
				var parts:Array = arr.split( "{" );
				var name:String = String( parts[0] );
				var qty:Array = String( parts[1] ).split( "," );
				var max:int, min:int;
				

				// 1, 	--> 1,-1   ( infinity... NOTE THAT THERE *IS* A COMMA, BUT NO SECOND DIGIT )
				// 1,3 	--> 1, 3
				// 1	--> 1, 1
				min = int( qty[ 0 ] );
				if ( qty.length == 1 ) // no max
				{
					max = min;
				}
				else
				{
					if ( String( qty[ 1 ] ).length > 0 )
						max = int( qty[ 1 ] );
					else
						max = -1; // we treat -1 as positive infinity
				}
				
				
				names[ i ] = new QuantifiedName( name, min, max );


			}			
					
		
		
			return names;
		
		}
		
		
		

	}

}


/*

sample input


Prologue  AnonProduction0  
BaseDecl? PrefixDecl*
KW0 IRI_REF
KW1 PNAME_NS IRI_REF
 AskQuery
KW8 DatasetClause* WhereClause
KW9  AnonProduction1 
 NamedGraphClause
KW10 SourceSelector
IRIref
 PrefixedName
 PNAME_NS
PNAME_LN 
IRI_REF 
 DefaultGraphClause 
SourceSelector
KW11? GroupGraphPattern
KW18 TriplesBlock?  AnonProduction2 * KW20
TriplesSameSubject  AnonProduction3 ?
 TriplesNode PropertyList
 BlankNodePropertyList
KW30 PropertyListNotEmpty KW31
Verb ObjectList  AnonProduction4 *
 KW29
VarOrIRIref 
 IRIref
Var 
 VAR2
VAR1 
Object  AnonProduction5 *
GraphNode
 TriplesNode
VarOrTerm 
 GraphTerm
 NIL
  BlankNode 
 ANON
BLANK_NODE_LABEL 
   BooleanLiteral  
 KW57
KW56 
    NumericLiteral   
 NumericLiteralNegative
 DOUBLE_NEGATIVE
  DECIMAL_NEGATIVE 
INTEGER_NEGATIVE  
  NumericLiteralPositive 
 DOUBLE_POSITIVE
  DECIMAL_POSITIVE 
INTEGER_POSITIVE  
NumericLiteralUnsigned  
 DOUBLE
  DECIMAL 
INTEGER  
     RDFLiteral    
String  AnonProduction6 ?
 STRING_LITERAL_LONG2
  STRING_LITERAL_LONG1 
   STRING_LITERAL2  
STRING_LITERAL1   
  AnonProduction7 
 KW55 IRIref
 LANGTAG 
IRIref     
Var 
 KW26 Object
 KW28  AnonProduction8 ?
 Verb ObjectList
Collection 
KW25 GraphNode+ KW27
PropertyListNotEmpty?
VarOrTerm PropertyListNotEmpty 
 KW19 TriplesBlock?
  AnonProduction9  KW19? TriplesBlock?
 Filter
KW24 Constraint
 FunctionCall
IRIref ArgList
 AnonProduction10 
 KW25 Expression  AnonProduction11 * KW27
ConditionalOrExpression
ConditionalAndExpression  AnonProduction12 *
ValueLogical  AnonProduction13 *
RelationalExpression
NumericExpression  AnonProduction14 ?
AdditiveExpression
MultiplicativeExpression  AnonProduction15 *
UnaryExpression  AnonProduction16 *
 PrimaryExpression
 Var
  BooleanLiteral 
   NumericLiteral  
    RDFLiteral   
     IRIrefOrFunction    
IRIref ArgList?
 AnonProduction17 
 KW25 Expression  AnonProduction18 * KW27
ConditionalOrExpression
 KW26 Expression
 NIL 
      BuiltInCall     
 RegexExpression
KW54 KW25 Expression KW26 Expression  AnonProduction19 ? KW27
 KW26 Expression
  KW53 KW25 Expression KW27 
   KW52 KW25 Expression KW27  
    KW51 KW25 Expression KW27   
     KW50 KW25 Expression KW27    
      KW49 KW25 Expression KW26 Expression KW27     
       KW48 KW25 Var KW27      
        KW47 KW25 Expression KW27       
         KW46 KW25 Expression KW26 Expression KW27        
          KW45 KW25 Expression KW27         
KW44 KW25 Expression KW27          
BrackettedExpression      
KW25 Expression KW27
  KW41 PrimaryExpression 
   KW40 PrimaryExpression  
KW43 PrimaryExpression   
 KW42 UnaryExpression
 KW5 UnaryExpression 
 NumericLiteralNegative
  NumericLiteralPositive 
   KW41 MultiplicativeExpression  
 KW40 MultiplicativeExpression   
 KW39 NumericExpression
  KW38 NumericExpression 
   KW37 NumericExpression  
    KW36 NumericExpression   
     KW35 NumericExpression    
 KW34 NumericExpression     
 KW33 ValueLogical
 KW32 ConditionalAndExpression
 KW26 Expression
 NIL 
  BuiltInCall 
BrackettedExpression  
 GraphPatternNotTriples 
 GraphGraphPattern
KW22 VarOrIRIref GroupGraphPattern
  GroupOrUnionGraphPattern 
GroupGraphPattern  AnonProduction20 *
 KW23 GroupGraphPattern
OptionalGraphPattern  
KW21 GroupGraphPattern
  DescribeQuery 
KW7  AnonProduction21  DatasetClause* WhereClause? SolutionModifier
 KW5
 VarOrIRIref+ 
OrderClause? LimitOffsetClauses?
KW12 KW13 OrderCondition+
  AnonProduction22 
 Var
 Constraint 
 AnonProduction23  
  AnonProduction24  BrackettedExpression
 KW15
 KW14 
 AnonProduction25 
 OffsetClause LimitClause?
KW17 INTEGER
KW16 INTEGER
 LimitClause OffsetClause? 
   ConstructQuery  
KW6 ConstructTemplate DatasetClause* WhereClause SolutionModifier
KW18 ConstructTriples? KW20
TriplesSameSubject  AnonProduction26 ?
 KW19 ConstructTriples?
 SelectQuery   
KW2  AnonProduction28 ?  AnonProduction27  DatasetClause* WhereClause SolutionModifier
 KW4
 KW3 
 KW5
 Var+  
 
 
 */