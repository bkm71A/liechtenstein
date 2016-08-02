package com.incheck.components.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class AnalysisTabEvent extends Event
	{
		public static var CURSOR_VALUES_UPDATED:String = "cursorValuesUpdated";
		
		public var cursorValues:ArrayCollection;
		public var xTitle:String;
		public var yTitle:String;
		public function AnalysisTabEvent(type:String)
		{
			super(type);
		}
	}
}