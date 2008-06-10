package com.googlecode.flashlr.parser.batch
{
	
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import com.googlecode.flashlr.grammar.Production;
	import com.googlecode.flashlr.parser.model.Expression;
	import com.googlecode.flashlr.parser.model.OR;
	import com.googlecode.flashlr.parser.model.ParserModel;
	import com.googlecode.flashlr.parser.model.Quantifier;
	import com.googlecode.flashlr.parser.model.Sequence;
	import com.googlecode.flashlr.parser.model.TerminalMatcher;
	import com.googlecode.flashlr.scanner.Token;
	
	
	/**
	 * 
	 * A simple recursive descent parser that runs to completion.
	 * Limitations: supports only greedy quantifiers and short circuiting OR
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class BatchParser
	{


		private var model:ParserModel;


		private var tokens:Array;
		
		
		private var logger:ILogger;
		
		

		
		private var count:int = 0;

		
		
		
		
		
		
		public function BatchParser( )
		{
			logger = Log.getLogger( getQualifiedClassName( this ).split( "::" ).join( "." ) );
		}
		
		
		
		

		public function parse( model:ParserModel, tokens:Array ):Node
		{
			
			count = 0;
			
			this.model		= model;
			
			this.tokens		= tokens;
			
			
			var node:Node = parseExpression( model.getRootExpression( ), 0 );
			
			
			if ( node == null )
			{
				
				trace( generateSyntaxError() );
				return null;

			}
			
			node.removePlaceHolders( );
			
			// trace( "Parser count " + count );
			
			return node;

		}









		private function getToken( index:int ):Token
		{
			return tokens[ index ] as Token;
		}




		
		private function parseExpression( e:Expression, index:int ):Node
		{
			
			var token:Token = getToken( index );
			
			count++;

			var node:Node;			

			// trace( e + "   " + index + token.image );

			///////////////////////////////////////
			// parse different types of expressions
			///////////////////////////////////////
			

			if ( e is Sequence )
			{
				node = parseSequence( e as Sequence, index );
			}
			else if ( e is TerminalMatcher )
			{
				node = parseTerminalMatcher( e as TerminalMatcher, index );
			}
			else if ( e is OR )
			{
				node = parseOR( e as OR, index );
			}
			else if ( e is Quantifier )
			{
				node = parseQuantifier( e as Quantifier, index );
			}
			
			
			// attach the production if one is available
			
			if ( e.production != null && node != null )
				node.production = e.production;		

			
		
			return node;
		}
		
		
		
		
		
		
		private function parseSequence( e:Sequence, index:int ):Node
		{

			var node:Node = new Node( index );

			var index2:int = index;
			

			for each ( var childExpr:Expression in e.children )
			{
				var childNode:Node = parseExpression( childExpr, index2 );
				
				if ( childNode == null )
				{
					return null; // TODO: error handling
				}
				else
				{
					index2 += childNode.length;
					node.addChild( childNode );
				} 
			
			}
			
			
			return node;
			
		}
		
		
		
		
		private function parseTerminalMatcher( e:TerminalMatcher, index:int ):Node
		{
			
			var token:Token =  getToken( index );
			
			if ( ( token != null ) && ( token.production == e.production ) )
			{
				var node:TerminalNode = new TerminalNode( index );
				node.token = token;
				return node;
			}
			
			
			registerTerminalFailure( e.production, token );
			
			
			return null;
		}
		
		
		
		
		private function parseOR( e:OR, index:int ):Node
		{
		
			var childNode:Node = parseOR_shortCircuit( e, index );
			
			if ( childNode == null )
				return null;
				
			var node:Node = new Node( index );
			node.addChild( childNode );
			
			return node;

		}
		
		
		
		private function parseOR_shortCircuit( e:OR, index:int ):Node
		{
			
			var node:Node = parseExpression( e.left, index );
			
			if ( node == null )
			{
				node = parseExpression( e.right, index );			
			}
			
			return node;
			
		}
		
		
		
		
		
		
		
		private function parseOR_both( e:OR, index:int ):Node
		{
			
			var leftNode		:Node = parseExpression( e.left, index );
			var rightNode		:Node = parseExpression( e.right, index );

			// if both failed, we also fail
			if ( leftNode==null && rightNode==null )
				return null;		


			if ( rightNode == null )
				return leftNode;

			if ( leftNode == null )
				return rightNode;
				
				
			// both matched... we return the longest
			
			if ( leftNode.length >= rightNode.length )
				return leftNode;
			else
				return rightNode;
				
				
			return null;// will never get here
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		private function parseQuantifier( e:Quantifier, index:int ):Node
		{
			
			var node:Node = new Node( index );
			
			var currentIndex:int = index;
			
			for ( var i:int=0; ; i++ )
			{
				
				if ( i == e.max )
				{
					return node;					// reached maximum
				}
				
				var newChildNode:Node = parseExpression( e.operand, currentIndex );
				
				
				if ( newChildNode == null )			// this match failed
				{
														// we fail upstream if we are under min, otherwise we pass				
					return ( i >= e.min ) ? node : null; 

				}
				else								// this match is OK, keep on looping
				{
					node.addChild( newChildNode );
					currentIndex += newChildNode.length;
				}
						
			}
			
			return null;							// will never get here				
		}
		
		
		
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////
		// failure and reporting
		////////////////////////////////////////////////////////
		
		
		
		private function generateSyntaxError( ):String
		{
			
			if ( ! failedProduction )
				return "Syntax Error: empty query";

			return "Syntax Error. Expected "  + failedProduction + " but found " + failedToken.image;
		
		
		}


		private var failedProduction:Production;

		private var failedToken:Token;
		

		private function registerTerminalFailure( production:Production, token:Token ):void
		{

			failedProduction = production;
			failedToken = token;	
					
		}		
		
		
		
		
		
		
		
		

		
		
		
		
		
		

	}


}