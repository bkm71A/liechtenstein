package com.incheck.components.model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="com.inchecktech.dpm.beans.ProcessDataVO")]

	public class ProcessDataVO
	{
		public var sampleId:String;	
		public var channelId:int;	
		public var dateTimeStamp:Date = new Date();	
		public var accelerationData:FunctionDataVO;	
		public var velocityData:FunctionDataVO;
		// Exponential Averages data for the acceleration
		public var accelerationDataAveragesExp:FunctionDataVO;
		// Exponential Averages data for the velocity
		public var velocityDataAveragesExp:FunctionDataVO;
		// Linear Averages data for the acceleration
		public var accelerationDataAveragesLinear:FunctionDataVO;
		// Linear Averages data for the velocity
		public var velocityDataAveragesLinear:FunctionDataVO;
		// PeakHold Averages data for the acceleration
		public var accelerationDataAveragesPeakHold:FunctionDataVO;
		// PeakHold Averages data for the velocity
		public var velocityDataAveragesPeakHold:FunctionDataVO;


		public function ProcessDataVO(obj:Object = null):void
		{
			if (obj)
			{	
				fromObject(obj);
			}	
		}
		
		
		public function fromObject(obj:Object):void
		{
			if (obj.hasOwnProperty("sampleId"))
			{
				sampleId = obj.sampleId;
			}	
			if (obj.hasOwnProperty("channelId"))
			{
				channelId = parseInt(obj.channelId, 10);
			}	
			if (obj.hasOwnProperty("dateTimeStamp"))
			{
				dateTimeStamp = obj.dateTimeStamp;
			}	
			if (obj.hasOwnProperty("accelerationData"))
			{
				accelerationData = obj.accelerationData as FunctionDataVO;
			}	
			if (obj.hasOwnProperty("velocityData"))
			{
				velocityData = obj.velocityData as FunctionDataVO;
			}	
		}	
	}
}