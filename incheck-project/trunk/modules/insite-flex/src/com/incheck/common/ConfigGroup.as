package com.incheck.common
{
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.config.ConfigGroup")]
	public class ConfigGroup
	{
		public var configGroupId:int;
		public var configGroupName:String;
		public var configGroupDescription:String;

		public function ConfigGroup()
		{
		}

	}
}