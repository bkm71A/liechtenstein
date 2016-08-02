
package com.incheck
{
	public class Status
	{
		public static var STATUS_OK:uint      = 0;
		public static var STATUS_WARNING:uint = 1;
		public static var STATUS_ERROR:uint   = 2;
		public static var STATUS_ALARM:uint   = 3;				
		
		private static var COLOR_OK:String      = "green";
		private static var COLOR_WARNING:String = "blue";
		private static var COLOR_ERROR:String   = "orange";
		private static var COLOR_ALARM:String   = "red";
		
		private static var COLOR_DEFAULT:String = "black";		
		
		public static function getStatusColor(status:uint):String{
			switch(status){
				case STATUS_OK:
					return COLOR_OK;
				case STATUS_ALARM:
					return COLOR_ALARM;
				case STATUS_WARNING:
					return COLOR_WARNING;
				case STATUS_ERROR:
					return COLOR_ERROR;
				default:
					return COLOR_DEFAULT;		
			}			
		}		
	}
}