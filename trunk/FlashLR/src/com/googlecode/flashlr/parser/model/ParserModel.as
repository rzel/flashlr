package com.googlecode.flashlr.parser.model
{
	
	import flash.utils.Dictionary;
	
	import com.googlecode.flashlr.grammar.Grammar;
	import com.googlecode.flashlr.grammar.NonTerminal;
	import com.googlecode.flashlr.grammar.Production;
	import com.googlecode.flashlr.grammar.Terminal;
	
	
	
	
	
	/**
	 * 
	 * The graph of operators
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class ParserModel
	{
	
	
	
		////////////////////////////////////////////
		// grammar
		////////////////////////////////////////////
	
		private var _grammar:Grammar;
		public function get grammar():Grammar
		{
			return _grammar;
		}
	
	
	
	
	
		////////////////////////////////////////////
		// constructor
		////////////////////////////////////////////
	
	
		public function ParserModel( grammar:Grammar )
		{
			_grammar = grammar;
		}
	
	
		
		
		
		
		
		
		/**
		 * 
		 * 
		 * Returns the compiled expression for a given NonTerminal.
		 * Compiling is lazy and only happens once.
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getExpression( name:String ):Expression
		{
			return getOrCreateExpr( name );
		}
	
		
		
		
		/**
		 * 
		 * equivalent to calling getExpression( grammar.rootProduction.name )
		 * 
		 * @return 
		 * 
		 */		
		public function getRootExpression():Expression
		{
			return getOrCreateExpr( grammar.rootProduction.name );
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
		private var name2expr:Object = {};
		
		private var anon2expr:Object = {};
	
	
		private function getOrCreateExpr( name:String ):Expression
		{
			
			
			var expr:Expression;
			
			
			if ( ! name2expr[ name ] ) // not requested yet. let's create it
			{
				
				var production:Production = grammar.getProduction( name );
				
				if ( production is NonTerminal )
				{
					
					expr = createExpr( (production as NonTerminal).expressionNoKeywords, name );
					expr.production = production;
				
				}	
				else if ( production is Terminal ) // this is the only way out of the loop... a terminal
				{
					
					expr = new TerminalMatcher( production as Terminal );
					expr.production = production;
				
				}
				else if ( anon2expr[ name ] )// the production does not exist in the grammar, but we created it as a means to factor out parenthesized expressions
				{
					
					expr = createExpr( String( anon2expr[ name ] ), name );					
				
				}
				
				
				
				if ( expr == null ) // TODO: raise error
					return null;				
				
				
				name2expr[ name ] = expr;	// some nodes register themselves as soon as they are created, before creating any children
											// this way we can use recursion ( remember this is not a tree, its a graph! )
			}
			
			return name2expr[ name ] as Expression;
		
		}
		
		
		
		
		
		
		
		
		
		
		private function createExpr( expression:String, name:String = null ):Expression
		{


			var i:int, term:String, min:int, max:int;
			
		
		
			// factor out all outer level of parens to new Anon Productions
			// ( they are local to the parser, never seen by the grammar )
			// this is our strategy to handle parens and their nesting
			
			expression = factorNestedParensToAnonExpressions( expression, createAnonProductionName, anon2expr );
			

			
			
			////////////////////////////////////////////////////////////////////
			// create an OR node? 
			////////////////////////////////////////////////////////////////////
			
			var orParts:Array = expression.split( "|" );
			if ( orParts.length > 1 )
			{
				var or:OR = new OR();
				if ( name ) // register right away to allow graph recursion
					name2expr[ name ] = or;
					
				or.left = ( createExpr( String( orParts.pop() ) ) ); 
				or.right = ( createExpr( String( orParts.join(" | ") ) ) ); 
				return or;	
			}

			
			
			
			///////////////////////////////////////////////////////////////////
			// at this point we only have a sequence of terms with quantifiers
			///////////////////////////////////////////////////////////////////
			
			
			var qName:QuantifiedName;
			
			var qNames:Array = QuantifiedName.parseSequence( expression );		
			
			

			if ( qNames.length == 0 )
			{
				// TODO: throw SyntaxError ?
			}			
			



			if ( qNames.length == 1 )
			{
				
				qName = qNames[ 0 ] as QuantifiedName;
				
//				if ( qName.isExactlyOne ) // spare the {1,1} quantifier
//				{
//					var expr:Expression = getOrCreateExpr( qName.name );
//					name2expr[ name ] = expr;			
//					return getOrCreateExpr( qName.name ); // this means that we can create aliases... ( two names for the same expression )		
//				}
//				else
//				{
					var quantifier:Quantifier = new Quantifier( qName.min, qName.max );
					if ( name )
					{ // always register before recursion to avoid infinite loops!!!
						name2expr[ name ] = quantifier;
					}
					quantifier.operand = getOrCreateExpr( qName.name );				
					return quantifier;			
//				}
				
				
			}
			
			
			
			
			////////////////////////////////////////////////////////////////////////////
			// if we got here, it has more than one quantified name... it is a sequence
			////////////////////////////////////////////////////////////////////////////
			
			
			var sequence:Sequence = new Sequence( );
			if ( name != null )
			{ // always register before recursion to avoid infinite loops!!!
				name2expr[ name ] = sequence;
			}
			
			
			var generatedNodes:Array = [];
			for each ( qName in qNames )
			{
				
				var e:Expression = getOrCreateExpr( qName.name );	

				if ( ! qName.isExactlyOne ) // need to quantify
				{
					var q:Quantifier = new Quantifier( qName.min, qName.max );			
					q.operand = e;
					e = q;				
				}
				
				// generatedNodes.push( e );

				sequence.children.push( e );

			}			

		
		
		
		
		
		
			

//			var current:Sequence = sequence;
//			while ( true )
//			{
//				current.left = ( generatedNodes.shift() );
//				if ( generatedNodes.length > 1 ) // sequences are only, we cascade-append them to create bigger lists
//				{
//					var next:Sequence = new Sequence();
//					current.right = next;
//					current = next;
//				}
//				else // finished the list
//				{
//					current.right = generatedNodes.shift() as Expression;
//					break;				
//				}
//			}
			
			return sequence;
		
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

		
		/**
		 * 
		 * Creates a non-colliding name ( not used in the grammar )
		 * 
		 * @return 
		 * 
		 */		
		private function createAnonProductionName():String
		{
			var name:String;
			while ( true )
			{
				
				name = "AnonProduction" + serialID++;
				if ( grammar.getProduction( name ) == null )
					break;
			}
			return name;
		}
		private var serialID:int=0;
		

		
		
		
		
		
		
		
		
		
		
		
		
		

		
		/**
		 * 
		 * @private
		 * 
		 * 
		 * This function is internal and static to allow unit testing
		 * 
		 * 
		 * @param expression
		 * @param anonNameGenerator
		 * @param anonNameToExpressionMap
		 * @return 
		 * 
		 */	
		internal static function factorNestedParensToAnonExpressions( expression:String, anonNameGenerator:Function, anonNameToExpressionMap:Object ):String
		{
		
		
			while ( true )
			{
				
				var openingParen:int = -1;
				var closingParen:int = -1;
				var depth:int = 0;
				
				for ( var i:int=0; i<expression.length; i++ )
				{
					var char:String = expression.charAt( i );
					if ( char == "(" )
						if ( ++depth == 1 ) // open a new pair
							openingParen = i;
	
					if ( char == ")" )
						if ( --depth == 0 ) // close current pair
							closingParen = i;
				}
			
			
				if ( openingParen == -1 )
				{
					break;// break the while loop, ther are no more parens to factor out
				}
			
				var nestedExpression:String 	= expression.substring( openingParen + 1, closingParen - 1  );
				var anonName:String 			= String( anonNameGenerator( ) );
				
				// store for later reference
				anonNameToExpressionMap[ anonName ] 	= nestedExpression;
				

				var before:String 				= expression.substring( 0, openingParen );
				var after:String 				= expression.substring( closingParen + 1 );
				expression = before + " " + anonName + " " + after;	
			
			}		
		
		
			return expression
		
		}
				
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////
		// dump
		///////////////////////////////////////////////////////////
		
		
		private var dumpLines:Array;
		


		/**
		 * 
		 * @return
		 * 		A ( possibly huge ) string representation containing a tree view
		 * 		of every expression in the graph
		 * 
		 */		
		public function dump( ):String
		{
			dumpLines = [ ];
			
			visit( dumpVisitor );
			
			var str:String = dumpLines.join("\n");
			dumpLines = null;
			
			return str;			
		}
		
		
		private function dumpVisitor( expr:Expression, firstVisit:Boolean, depth:int ):*
		{
			
//			if ( ! firstVisit )
//				return;
			
			var str:String = "";
			for ( var i:int=0; i<depth; i++ )
			{
				str += "- ";
			}
			
		
			str += expr.toString( );
			if ( !firstVisit )
			{
				str += "(children collapsed)";
			}
		
			dumpLines.push( str );
		
		}		
		
		

		
		
		
		
		
		
		
		
		///////////////////////////////////////////////
		// visit
		///////////////////////////////////////////////
		
		
		
		private var visitedExpressions:Dictionary;
		
		
		
		/**
		 * 
		 * Visits all the expressions in the graph using a user defined Function.
		 * Traversal starts at the root expression and continues by traversing outgoing operator edges, depth first.
		 * Edges from Binary operators are traversed in a left-right order.
		 * <p>
		 * Every node is visited once and then marked as "visited". If it occurrs again ( it is reached by other edges )
		 * It will be visited again, but this time the parameter "firstVisit"  will be set to false.
		 * Its exiting edges will only be traversed after the first visit ( this allows us to treat the graph as a tree ).
		 * </p>
		 * 
		 * Sample function
		 * <pre>
		 * 
		 * function visit( expr:Expression, firstVisit:Boolean, depth:int ):*
		 * {
		 * 		
		 * 		trace( "visiting" + expr + ( firstVisit ? " for the first time" : "" ) );
		 * 		
		 * 		if ( expr.production && expr.production.name == "InterestingProduction" )
		 * 		{
		 * 			return true; // stop here
		 * 		}
		 * }
		 * 
		 * 
		 * </pre>
		 * 
		 * To stop graph traversal at any point make your function return "true".
		 * 
		 * @param func
		 * 
		 */		
		public function visit( func:Function ):void
		{
		
			visitedExpressions = new Dictionary( );
			doVisit( getRootExpression( ), func, 0 );
			visitedExpressions = null;
		}
		
		
		
		private function doVisit( expr:Expression, func:Function, depth:int ):void
		{
		
			
			var firstVisit:Boolean = true;
			
			if ( visitedExpressions[ expr ] == true )
				firstVisit = false;
			else
				visitedExpressions[ expr ] = true;


			
			if ( func.apply( null, [ expr, firstVisit, depth ] ) )
			{
				return; // user function returned true. we exit.			
			}
			
			
			if ( ! firstVisit ) // only go to children on first visit
				return;

			
			depth += 1;
				
		
			if ( expr is UnaryOperator )
			{
				
				doVisit( ( expr as UnaryOperator ).operand, func, depth );
			}
			else if ( expr is BinaryOperator )
			{
				doVisit( ( expr as BinaryOperator ).left	, func, depth );
				doVisit( ( expr as BinaryOperator ).right	, func, depth );
			}			
			else if ( expr is Sequence )
			{
				
				for each ( var subExpr:Expression in expr.subExpressions )
				{
					doVisit( subExpr, func, depth );
				}
							
			}
		
		}
		
		

		
		
		
	}

}