package com.incheck.common
{
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.config.ConfigType")]
	public class ConfigType
	{
		public var configTypeId:int;
		public var configTypeName:String;
		public var configTypeDescription:String;

		public function ConfigType()
		{
		}

	}
}