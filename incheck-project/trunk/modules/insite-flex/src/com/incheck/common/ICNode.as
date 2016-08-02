package com.incheck.common
{
    import mx.collections.ArrayCollection;

    [Managed]
    [RemoteClass(alias="com.inchecktech.dpm.beans.ICNode")]
    public class ICNode
    {
        public var name:String;
        public var id:int;
        public var channelid:int;
        public var rpm:Number;
        public var rms:Number;
        public var desc:String;
        public var type:String;
        public var label:String;
        public var state:int = 0;
        public var parent:ICNode;
        public var children:ArrayCollection;
        public var numberOfSamples:Number;
        public var samplingRate:Number;
        public var deviceId:Number;
        public var latestTimeStamp:Number;
        public var dataUnits:Number;
        public var processedDataKeysString:ArrayCollection;
        public var latestData:Object;
        public var channelType:int;
        public var measureType:String;
        public var incomingDataTimestamp:Date;
		
		public function ICNode()
		{
			
		}
    }
}