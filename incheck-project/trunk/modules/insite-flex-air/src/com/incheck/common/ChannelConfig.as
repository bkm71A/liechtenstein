package com.incheck.common
{
	import mx.collections.ArrayCollection;
			
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.config.ChannelConfig")]
	public class ChannelConfig
	{
		public var configGroup:ConfigGroup;
		public var configType:ConfigType;
		public var userControl:int;
		public var channelConfigItems:ArrayCollection;
		
		public function ChannelConfig()
		{
		}

	}
}