package com.incheck.components.events
{
	import flash.events.Event;
	
	public class InCheckEvent extends Event
	{
		public static const SAVE_GRAPH:String = "saveGraph";
		public static const CREATE_SCREEN:String = "createScreen";
		
		public function InCheckEvent(type:String)
		{
			super(type);
		}
	}
}