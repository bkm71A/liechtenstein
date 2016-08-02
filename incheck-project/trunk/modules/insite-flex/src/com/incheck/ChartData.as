package com.incheck
{
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	/**
	 * Chart Data holder for a single chart
	 */
	public class ChartData
	{
		private var _arrayCollection:ArrayCollection;
		private var _lineSeries:LineSeries;
		
		public function ChartData(arrayCollection:ArrayCollection, lineSeries:LineSeries){
			this._arrayCollection = arrayCollection;
			this._lineSeries = lineSeries;
		}
		
		public function get arrayCollection():ArrayCollection{
			return _arrayCollection;
		}
		
		public function get lineSeries():LineSeries{
			return _lineSeries;
		}
		
		public function handleRes(event:ResultEvent):void {
			_arrayCollection.source=(event.result as ArrayCollection).source;

		}
		public function faultHandler (event:FaultEvent):void {
			Alert.show(event.fault.faultString, 'Error');
		}
	}
}
