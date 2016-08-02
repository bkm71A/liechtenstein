package com.incheck.components.model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="com.inchecktech.dpm.beans.GraphDataVO")]
	public class GraphDataVO
	{
		public var chartData:ArrayCollection;
		public var eu:Object;				// ?
		public var max:Number;	
		public var min:Number;	
		public var measurementType:String;	// "Absolute, Delta";	
		public var measurementUnit:String;	// "ms, Hz";
		public var overalls:Object = null;	
		public var samplingRate:Number;	
		public var XEUnit:String;			// "TimeSec, FreqHz"
		public var YEUnit:String;			// "VelInSec, AccG";
		public var XSymbol:String;			// "s, Hz"
		public var YSymbol:String;			// "g";	
		public var XPhysDomain:String;		// "Time, Frequency"
		public var YPhysDomain:String;		// "Velocity, Acceleration";	

		
		public function GraphDataVO(obj:Object = null):void
		{
			if (obj)
			{	
				fromObject(obj);
			}	
		}
		
		
		public function fromObject(obj:Object):void
		{
			if (obj.hasOwnProperty("chartData"))
			{
				chartData = obj.chartData;
			}	
			if (obj.hasOwnProperty("eu"))
			{
				eu = obj.eu;
			}	
			if (obj.hasOwnProperty("max"))
			{
				max = obj.max;
			}	
			if (obj.hasOwnProperty("min"))
			{
				min = obj.min;
			}	
			if (obj.hasOwnProperty("measurementType"))
			{
				measurementType = obj.measurementType;
			}	
			if (obj.hasOwnProperty("measurementUnit"))
			{
				measurementUnit = obj.measurementUnit;
			}	
			if (obj.hasOwnProperty("overalls"))
			{
				overalls = obj.overalls;
			}	
			if (obj.hasOwnProperty("samplingRate"))
			{
				samplingRate = obj.samplingRate;
			}	
			if (obj.hasOwnProperty("XEUnit"))
			{
				XEUnit = obj.XEUnit;
			}	
			if (obj.hasOwnProperty("YEUnit"))
			{
				YEUnit = obj.YEUnit;
			}	
			if (obj.hasOwnProperty("XSymbol"))
			{
				XSymbol = obj.XSymbol;
			}	
			if (obj.hasOwnProperty("YSymbol"))
			{
				YSymbol = obj.YSymbol;
			}	
			if (obj.hasOwnProperty("XPhysDomain"))
			{
				XPhysDomain = obj.XPhysDomain;
			}	
			if (obj.hasOwnProperty("YPhysDomain"))
			{
				YPhysDomain = obj.YPhysDomain;
			}	
		}	
	}
}