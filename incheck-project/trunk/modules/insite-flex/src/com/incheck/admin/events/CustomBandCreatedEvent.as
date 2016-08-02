package com.incheck.admin.events
{
	import flash.events.Event;
	
	public class CustomBandCreatedEvent extends Event
	{
		public static const CUSTOM_BAND_CREATED:String = "customBandCreated";
		public var name:String;
		public var startFreq:String;
		public var endFreq:String;
		
		public function CustomBandCreatedEvent(name:String,startFreq:String,endFreq:String)
		{
			this.name = name;
			this.startFreq = startFreq;
			this.endFreq = endFreq;
			super(CUSTOM_BAND_CREATED, true, false);
		}
	}
}