
package com.incheck.common
{
	import mx.collections.ArrayCollection;
	
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.beans.User")]
	public class User
	{
		
		public var userId:int;
		
		public var userName:String;

		public var firstName:String;

		public var lastName:String;
		public var email:String;
		public var title:String;
		public var userroles:ArrayCollection;
		public var usersession:UserSession;
		public var enabled:Boolean;
		private var verified:Boolean;
		private var mailist:Boolean;
		private var contactlist:Boolean;
		private var organization:String;
		private var industry:String;
		private var howdidyouhear:String;
		
		
		public function User()
		{
			
		}	

	}
}