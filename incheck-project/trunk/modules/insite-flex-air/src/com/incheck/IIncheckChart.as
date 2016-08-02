package com.incheck
{
	import com.incheck.common.ICNode;
	
	import mx.charts.HitData;

	
	public interface IIncheckChart
	{
		function resetVerticalZoom():void
		
		function resetHorizontalZoom():void
		
		function regenLineSeriesWithZoomReset():void
		
		function setupConversion():void
		
		function regenLineSeries():void
		
		function setDashboardColors():void
		
		function dataTipsFunc(event:HitData):String
		
		function onAutoScaleChanged():void
		
		function clearData():void
		
		function isNodePresent(node:ICNode):Boolean

		function invalidate():void
		
	}
}