package com.incheck.common
{	
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.beans.UserPreference")]
	public class UserPreference
	{
		public var id:int;
		public var key:String;
		public var value:String;
		public var type:String;
		public var level:int;
		public var description:String;
		
		
		public function UserPreference()
		{
			
		}	

	}
}