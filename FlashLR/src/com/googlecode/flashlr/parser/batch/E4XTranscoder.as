package com.googlecode.flashlr.parser.batch
{
	
	import com.googlecode.flashlr.grammar.Terminal;


	public class E4XTranscoder
	{

		

		
		public static function toXML( node:Node ):XML
		{
			
			if ( node == null )
				return null;
			
			
			var xml:XML = new XML( "<foo/>" ); // root name is irrelevant
			

			var tn:TerminalNode 	= node as TerminalNode;
			var tp:Terminal 		= node.production as Terminal;
			
			/////////////////////////////////////////////////////
			// index
			/////////////////////////////////////////////////////
			xml.@index = node.index;



			/////////////////////////////////////////////////////
			// image
			/////////////////////////////////////////////////////
			
			if ( tn )
				xml.@image = tn.token.image;	
			
			
			/////////////////////////////////////////////////////
			// name
			/////////////////////////////////////////////////////
			
			if ( tp && tp.isKeyword  )
				xml.setName( "_kw_" ); // keywords can be invalid xml names. we place them all with _kw_
			else
				xml.setName( node.production.name );
			


			/////////////////////////////////////////////////////
			// recursion...
			/////////////////////////////////////////////////////
			
			for each ( var childNode:Node in node.children )
			{
				var childXML:XML = toXML( childNode );
				xml.appendChild( childXML );
			}
			

				
				
			return xml;
			
		}
		
	}

}