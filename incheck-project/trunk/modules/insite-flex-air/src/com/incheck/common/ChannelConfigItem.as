package com.incheck.common
{
	import com.incheck.common.Unit;
	
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.config.ChannelConfigItem")]
	public class ChannelConfigItem
	{	
		public var channel_id:int;
		public var property_id:int;  
		public var propertyName:String;
		public var propertyValue:String;
		public var description:String;
		public var defaultValue:String;
		public var dataType:String;
		public var unit:Unit;
		
		public function ChannelConfigItem()
		{
		}

	}
}