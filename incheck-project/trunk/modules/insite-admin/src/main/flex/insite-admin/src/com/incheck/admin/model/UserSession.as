
package com.incheck.admin.model
{
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.beans.UserSession")]
	public class UserSession
	{
		
		public var sessionId:String;
		public var userid:int;
		public var createDate:Date;
		public var modifiedDate:Date;	
		public var attributes:Object;
	
	}
}