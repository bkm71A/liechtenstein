package com.incheck.common
{
    import mx.collections.ArrayCollection;

    [Managed]
    [RemoteClass(alias="com.inchecktech.dpm.beans.DeviceEvent")]
    public class DeviceEvent
    {
        public var deviceId:int;

        public var deviceMac:String;

        public var operation:String;

        public var timestamp:Date;
		
		
		function DeviceEvent():void
		{
			
		}
    }
}