package com.googlecode.flashlr.scanner
{
	
	import com.googlecode.flashlr.grammar.Terminal;
	
	
	/**
	 *  
	 * 
	 *  @eventType com.googlecode.flashlr.scanner.TokenEvent.IMAGE_CHANGED
	 */
	[Event(name="imageChanged", type="com.googlecode.flashlr.scanner.TokenEvent")]	
	
	/**
	 *  
	 * 
	 *  @eventType com.googlecode.flashlr.scanner.TokenEvent.INDEX_CHANGED
	 */
	[Event(name="indexChanged", type="com.googlecode.flashlr.scanner.TokenEvent")]	
	
	
	
	
	
	/**
	 * 
	 * 
	 * 
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public class Token
	{
	
		private var _production:Terminal;
		[Bindable("change")] // just to avoid binding warnings
		public function get production():Terminal
		{
			return _production;
		}
		
		
		private var _image:String;
		[Bindable("imageChanged")]
		public function get image():String
		{
			return _image;
		}
		
		
		private var _index:int;
		[Bindable("indexChanged")]
		public function get index():int
		{
			return index;
		}
	
	
		/**
		 * 
		 * @param production
		 * @param image
		 * @param index for now we are allowing undefined indexes ( equal to -1 ). any usecases for this?
		 * 
		 */	
		public function Token( production:Terminal, image:String, index:int = -1 )
		{
			_production		= production;
			_image			= image;	
			_index			= index;	
		}
		
		
		public function toString():String
		{
			return "Token( " + production.name + " ) = " + image;		
		}
		
	}
	
}