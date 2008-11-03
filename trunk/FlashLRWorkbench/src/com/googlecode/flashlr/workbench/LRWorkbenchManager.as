package com.googlecode.flashlr.workbench
{


	import com.googlecode.flashlr.grammar.Grammar;
	import com.googlecode.flashlr.grammar.lib.SPARQLGrammar;
	import com.googlecode.flashlr.parser.batch.BatchParser;
	import com.googlecode.flashlr.parser.batch.Node;
	import com.googlecode.flashlr.parser.model.ParserModel;
	import com.googlecode.flashlr.scanner.ITokenStream;
	import com.googlecode.flashlr.scanner.Scanner;
	import com.googlecode.flashlr.scanner.Token;
	import com.googlecode.flashlr.workbench.ui.ASTPod;
	import com.googlecode.flashlr.workbench.ui.ConsolePod;
	import com.googlecode.flashlr.workbench.ui.GrammarModelPod;
	import com.googlecode.flashlr.workbench.ui.GrammarSourcePod;
	import com.googlecode.flashlr.workbench.ui.ParserModelPod;
	import com.googlecode.flashlr.workbench.ui.SourcePod;
	import com.googlecode.flashlr.workbench.ui.TokensPod;
	
	import flash.events.EventDispatcher;

	
	public class LRWorkbenchManager extends EventDispatcher
	{


		private var dh:DependencyHelper;


		
		//////////////////////////////////////
		// pods
		//////////////////////////////////////

		public var grammarSourcePod:GrammarSourcePod;
		
		public var grammarModelPod:GrammarModelPod;
		
		public var consolePod:ConsolePod;
		
		public var astPod:ASTPod;
		
		public var sourcePod:SourcePod;

		public var parserModelPod:ParserModelPod;

		public var tokensPod:TokensPod;




		//////////////////////////////////////
		// grammar
		//////////////////////////////////////
		
		private var grammarSpec:DependencySpec = new DependencySpec( "grammar", "grammarChanged" );
		
		[Bindable("grammarChanged")]
		public function get grammar( ):Grammar
		{
			return dh.getDependencyValue( grammarSpec );
		}
		public function set grammar( v:Grammar ):void
		{
			
			if ( dh.setDependencyValue( grammarSpec, v ) )
			{
				updateParserModel( );
			}
		}
		
		private function updateGrammar( ):void
		{
			// this will be called when we include a source to grammar parser		
		}




		//////////////////////////////////////
		// parserModel
		//////////////////////////////////////

		private var parserModelSpec:DependencySpec = new DependencySpec( "parserModel", "parserModelChanged" );
		
		[Bindable("parserModelChanged")]
		public function get parserModel( ):ParserModel
		{
			return dh.getDependencyValue( parserModelSpec );
		}
		public function set parserModel( v:ParserModel ):void
		{
			
			if ( dh.setDependencyValue( parserModelSpec, v ) )
			{
				updateAST( );
			}
		}

		private function updateParserModel( ):void
		{

			if ( grammar )
			{
				parserModel = new ParserModel( grammar );
			}
			else
			{
				parserModel = null;
			}
			
		}




		//////////////////////////////////////
		// AST root node
		//////////////////////////////////////

		private var astSpec:DependencySpec = new DependencySpec( "ast", "astChanged" );
		
		[Bindable("astChanged")]
		public function get ast( ):Node
		{
			return dh.getDependencyValue( astSpec );
		}
		public function set ast( v:Node ):void
		{
			
			if ( dh.setDependencyValue( astSpec, v ) )
			{
				// cascade ends here for now
			}
		}

		private function updateAST( ):void
		{
			trace( "updateAST()" );
			if ( parserModel && tokens )
			{
				ast = new BatchParser( ).parse( parserModel, tokens );
			}
			else
			{
				ast = null;
			}
			
		}



		//////////////////////////////////////
		// tokens
		//////////////////////////////////////

		private var tokensSpec:DependencySpec = new DependencySpec( "tokens", "tokensChanged" );
		
		[Bindable("tokensChanged")]
		public function get tokens( ):Array
		{
			return dh.getDependencyValue( tokensSpec );
		}
		public function set tokens( v:Array ):void
		{
			
			if ( dh.setDependencyValue( tokensSpec, v ) )
			{
				updateAST( );
			}
		}

		private function updateTokens( ):void
		{
			
			if ( grammar && source )
			{
				
				var scanner:Scanner = new Scanner( grammar );
				
				var r:ITokenStream = scanner.scan( source );
				
				var newTokens:Array = [];
						
				while ( r.hasNext( ) )
				{
					var t:Token = r.next( );
					if ( t.production.name == 'WS' ) continue; // TODO: we have to figure out a way to indicate skipping
					newTokens.push( t );
				}
				
				 tokens = newTokens;				
				
			}
			else
			{
				tokens = null;
			}
			
		}




		//////////////////////////////////////
		// source
		//////////////////////////////////////

		private var sourceSpec:DependencySpec = new DependencySpec( "source", "sourceChanged" );
		
		[Bindable("sourceChanged")]
		public function get source( ):String
		{
			return dh.getDependencyValue( sourceSpec );
		}
		
		public function set source( v:String ):void
		{
			
			if ( dh.setDependencyValue( sourceSpec, v ) )
			{
				updateTokens( );
			}
		}

		private function updateSource( ):void
		{
		}

























				
		public function LRWorkbenchManager( )
		{
			
			
			dh = new DependencyHelper( this );
			
			
			
			// this instantiation should be queued or deferred
			
		
			grammarSourcePod 	= new GrammarSourcePod( );
			
			grammarModelPod 	= new GrammarModelPod( );
		
			consolePod 			= new ConsolePod( );
			
			astPod 				= new ASTPod( );
			
			sourcePod 			= new SourcePod( );
			
			parserModelPod 		= new ParserModelPod( );
			
			tokensPod 			= new TokensPod( );
		
			
			
			// hard coded for now
			grammar = SPARQLGrammar.getGrammar( );
			
		
		}
		
		

		
		
		
		
		
		
		/////////////////////////////////
		// singleton
		/////////////////////////////////		
		
		
		private static var instance:LRWorkbenchManager;
		public static function getInstance( ):LRWorkbenchManager
		{
			if ( !instance )
				instance = new LRWorkbenchManager( );
			return instance;
		}
		
		public static function get i():LRWorkbenchManager
		{
			return getInstance();
		}
		

	}
	
}