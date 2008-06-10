package com.googlecode.flashlr.scanner
{

	import flash.events.Event;


	public class TokenEvent extends Event
	{
		

		public static const IMAGE_CHANGED:String = "imageChanged";
		

		public static const INDEX_CHANGED:String = "indexChanged";
		
		
		public function TokenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}

}