package com.incheck
{
	import com.incheck.admin.events.ThresholdSettingsEvent;
	import com.incheck.model.ChartDataPointVO;
	import com.incheck.model.LoginModel;
	
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import mx.charts.Legend;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;
	
	import spark.components.VGroup;


	public class IncheckGraph extends VGroup
	{
		private var legend:Legend;

		private var zoom:uint = 1;

		//private var _cursor:Canvas = new Canvas();

		protected var _channelType:String = com.incheck.IncheckConstants.CHART_TYPE_TREND;

		private var _chart:IChart;

		private var _chartName:String;

		private var _channelId:Number;

		private var _warningValue:Number;

		private var _alarmValue:Number;

		private var ro:RemoteObject;

		[Bindable]
		public var lastDataPointY:Number = 0;

		[Bindable]
		public var chartDP:ArrayCollection = new ArrayCollection();

		public var chDisplayObj:ChannelDisplay;

		private var numFormatter:NumberFormatter;

		public var _yConversionFunc:Function;

		public var shouldRun:Boolean = true;


		/**
		 * Constructor
		 */
		public function IncheckGraph()
		{
		}


		override protected function createChildren():void
		{
			super.createChildren();
		}


		public function initChart(channelId:Number, channelType:String, yConversionFunc:Function):void
		{
			_channelId = channelId;
			_channelType = channelType;//IncheckDataProvider.getChartName(channelType);
			numFormatter = new NumberFormatter();
			numFormatter.precision = 3;
			if (channelType == "Recent Trend")
			{	
				_chart = new VBarChart();
			}
			else
			{
				_chart = new GaugeChart();
			}
			_chart.percentWidth = 100;
			_chart.percentHeight = 100;
			_yConversionFunc = yConversionFunc;
			addElement(IVisualElement(_chart));
		}


		public function get chartName():String
		{
			return _chart.title;
		}


		public function set chartName(value:String):void
		{
			_chart.title = value;
		}


		/**
		 * Registers current chart
		 */
		public function register():void
		{
			ro = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, getEventThresholdsResult, false, 0, true);
			ro.addEventListener(FaultEvent.FAULT, getEventThresholdsFault, false, 0, true);
			ro.getEventThresholds(_channelId);
		}


		private function getEventThresholdsResult(event:ResultEvent):void
		{
			if (event.result != null)
			{
				var thresholdSettings:ArrayCollection = event.result as ArrayCollection;
				for each (var item:Object in thresholdSettings)
				{
					if (item.severity == 1)
					{
						if (!isNaN(_warningValue))
						{
							if (item.event_tr_upper_bound < _warningValue)
							{
								_warningValue = item.event_tr_upper_bound;
							}
						}
						else
						{	
							_warningValue = item.event_tr_upper_bound;
						}	
					}
					if (item.severity == 2)
					{
						if (!isNaN(_alarmValue))
						{
							if (item.event_tr_upper_bound < _alarmValue)
							{
								_alarmValue = item.event_tr_upper_bound;
							}
						}
						else
						{	
							_alarmValue = item.event_tr_upper_bound;
						}	
					}
				}
				_chart.warningValue = _warningValue;
				_chart.alertValue = _alarmValue;
				// Remove previous listeners
				ro.removeEventListener(ResultEvent.RESULT, getEventThresholdsResult);
				ro.removeEventListener(FaultEvent.FAULT, getEventThresholdsFault);
				// Set listeners for the dashboard data
				ro.addEventListener(ResultEvent.RESULT, getDashboardDataResult, false, 0, true);
				ro.addEventListener(FaultEvent.FAULT, getDashboardDataFault, false, 0, true);
				// get data for graph
				getDashboardData();
			}
		}
		
				
		private function getDashboardData():void
		{
			//			ro.getProcessedDataObj(new Number(_channelId), _chartType, "0");
			ro.getDashboardData(_channelId, _channelType);
		}

			
		private function getEventThresholdsFault(event:FaultEvent):void
		{
			Alert.show(event.fault.faultString, 'Error');
			trace(event.fault.faultString);
		}

		
		private function getDashboardDataResult(event:ResultEvent):void
		{
			if (event.result == null)
			{
				setTimeout(getDashboardData, 5000);
				return;
			}
			var pData:Object = ObjectProxy(event.result).object_proxy::object as Object;
			if (pData == null)
			{
				//Alert.show("No pData for id: "+id+" type: " + _chartType)
				return;
			}
			if (pData.chartData == null)
			{
				//Alert.show("No processedData.chartData for id: "+id+" type: " + _chartType)
				return;
			}
			// convert to the user's preferred units
			var newArr:Array = pData.chartData.source as Array;
			var l:int = newArr.length;
			var dataPoint:ChartDataPointVO;
			for (var i:int = 0; i < l; i++)
			{
				dataPoint = new ChartDataPointVO(newArr[i]);
//				dataPoint.y = yConversionFunction(dataPoint.y);
				newArr[i] = dataPoint;
			}

			var lastDataPoint:ChartDataPointVO = newArr[l - 1];
			lastDataPointY = lastDataPoint.y;
			

			var displayedPrecision:int = IncheckModel.instance().userPreferencesModel.displayedPrecision;
			_chart.displayedPrecision = displayedPrecision;
			_chart.rmsValue = (_chart is GaugeChart) ? Math.abs(lastDataPointY) : (_yConversionFunc != null ? _yConversionFunc(lastDataPointY) : lastDataPointY);

			if (chDisplayObj != null)
			{
				if(_chart is VBarChart)
					chDisplayObj.valueLabel.text = _chart.rmsValue.toFixed(1);
				else
					chDisplayObj.valueLabel.text = _chart.rmsValue.toFixed(displayedPrecision);
				
				var dateFormatter:DateFormatter = new DateFormatter();
				dateFormatter.formatString = "MM/DD/YYYY LL:NN:SS A";	
				chDisplayObj.timeLabel.text = dateFormatter.format(pData.dateTimeStamp);
			}
			if (shouldRun)
			{
				setTimeout(getDashboardData, 5000);
			}
		}


		private function getDashboardDataFault(event:FaultEvent):void
		{
//			Alert.show(event.fault.faultString, 'Error');
			trace(event.fault.faultString);
			setTimeout(getDashboardData, 5000);
		}
	}
}
