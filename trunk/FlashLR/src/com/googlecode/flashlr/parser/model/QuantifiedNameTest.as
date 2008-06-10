package com.googlecode.flashlr.parser.model
{

	import flexunit.framework.TestCase;


	public class QuantifiedNameTest extends TestCase
	{



		public function test_parseSequence( ):void
		{
			
			var qNames:Array;
			
			qNames = QuantifiedName.parseSequence( "KW2  AnonProduction28 ?  AnonProduction27  DatasetClause*   WhereClause          + SolutionModifier" );					
		
			assertEquals( qNames.length, 6 );
			assertEquals( qNames[ 0 ].toString(), "KW2{1,1}" );
			assertEquals( qNames[ 1 ].toString(), "AnonProduction28{0,1}" );
			assertEquals( qNames[ 2 ].toString(), "AnonProduction27{1,1}" );
			assertEquals( qNames[ 3 ].toString(), "DatasetClause{0,-1}" );
			assertEquals( qNames[ 4 ].toString(), "WhereClause{1,-1}" );
			assertEquals( qNames[ 5 ].toString(), "SolutionModifier{1,1}" );



		
		
			qNames = QuantifiedName.parseSequence( "SingleProduction" );					
		
			assertEquals( qNames.length, 1 );
			assertEquals( qNames[ 0 ].toString(), "SingleProduction{1,1}" );


		}

		
	}
	
}