package com.googlecode.flashlr.scanner
{
	
	/**
	 * 
	 * @author aldo.bucchi@gmail.com
	 * 
	 */	
	public interface ITokenStream
	{
		
		function next():Token;
		
		function hasNext():Boolean;
	
	}

}