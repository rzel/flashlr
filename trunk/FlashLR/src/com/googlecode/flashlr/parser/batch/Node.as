package com.googlecode.flashlr.parser.batch
{

	
	import com.googlecode.flashlr.grammar.Production;
	
	
	public class Node
	{
		
		public var production:Production;
		
		
		public var children:Array = [];
		
		
		public var parent:Node;	
		
		
		public var index:int;
		
		
		
		/**
		 * 
		 * Length is measured in terms of Tokens.
		 * 
		 * @return 
		 * 
		 */		
		public function get length( ):int
		{
			var l:int = 0;
			for each ( var childNode:Node in children )
				l += childNode.length;
			
			return l;
		}
		
		
		
		public function get isPlaceHolder( ):Boolean
		{
			return ( production == null );
		}
		
		
		
		

		
		
		
		public function Node( index:int )
		{
			this.index = index;
		}
		
		
		
		
		public function addChild( node:Node ):void
		{
			node.parent = this;
			children.push( node );
		}
		
		
		
		

		/**
		 * 
		 * NOTE: this will replace our children array for a different instance
		 * Do not keep an external reference to it
		 * 
		 */	
		public function removePlaceHolders( ):void
		{
			
			var newChildren:Array = [ ];

			for each ( var child:Node in children )
			{
				child.removePlaceHolders( );
				
				if ( child.isPlaceHolder ) // we steal his kids hehe
					for each ( var grandChild:Node in 	child.children )
						newChildren.push( grandChild );					
				else
					newChildren.push( child );
			}
			
			children = newChildren;
				
		}
		
		
		
		
		
		public function toString( ):String
		{

			if ( production == null )
			{
				return "*";	
			}
			
			return "NT " + production.name;		

		}
		
		
		
		
		

	}

}