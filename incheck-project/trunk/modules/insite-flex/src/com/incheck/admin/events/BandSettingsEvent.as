package com.incheck.admin.events
{
	import com.incheck.common.Band;
	
	import flash.events.Event;
	
	public class BandSettingsEvent extends Event
	{
		public static const DELETE_BAND : String = "deleteBand";
		
		private var _band : Band;
		
		public function BandSettingsEvent(type:String, band : Band)
		{
			super(type);
			_band = band;
		}
		
		
		public function get band() : Band {
			return _band;
		}
	}
}