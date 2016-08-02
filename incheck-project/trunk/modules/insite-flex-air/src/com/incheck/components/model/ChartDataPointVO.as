package com.incheck.components.model
{
	import flash.geom.Point;

	
	public class ChartDataPointVO
	{
		public var bufferSize:Number = 0;
		public var sev1Lower:Number = 0;
		public var sev1Upper:Number = 0;
		public var sev2Lower:Number = 0;
		public var sev2Upper:Number = 0;
		public var x:Number = 0;
		public var y:Number = 0;
		
		
		public function ChartDataPointVO(obj:Object = null):void
		{
			if (obj)
			{
				fromObject(obj);
			}	
		}
		
		
		public function fromObject(obj:Object):void
		{
			if (obj.hasOwnProperty("buffersize"))
			{
				bufferSize = obj.buffersize;
			}	
			if (obj.hasOwnProperty("sev1Lower"))
			{
				sev1Lower = obj.sev1Lower;
			}	
			if (obj.hasOwnProperty("sev1Upper"))
			{
				sev1Upper = obj.sev1Upper;
			}	
			if (obj.hasOwnProperty("sev2Lower"))
			{
				sev2Lower = obj.sev2Lower;
			}	
			if (obj.hasOwnProperty("sev2Upper"))
			{
				sev2Upper = obj.sev2Upper;
			}	
			if (obj.hasOwnProperty("x"))
			{
				x = obj.x;
			}	
			if (obj.hasOwnProperty("y"))
			{
				y = obj.y;
			}	
		}	
	}
}