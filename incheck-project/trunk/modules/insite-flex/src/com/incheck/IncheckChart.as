package com.incheck
{
	import com.incheck.components.CustomLinearAxis;
	import com.incheck.model.ChartDataPointVO;
	
	import flash.utils.setTimeout;
	
	import mx.charts.Legend;
	import mx.charts.LineChart;
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	import mx.formatters.NumberFormatter;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;
	

	public class IncheckChart extends LineChart
	{		
		private var legend:Legend;
		private var zoom:uint = 1;
		//private var _cursor:Canvas = new Canvas();
		
		protected var _chartType:String = com.incheck.IncheckConstants.CHART_TYPE_TREND;
		private var _chartName:String;
		
		private var _mouseOver:Boolean = false;
		[Bindable]
		public var lastDataPointY:Number = 0;
		[Bindable]
		public var chartDP:ArrayCollection = new ArrayCollection();
		
		public var chDisplayObj:ChannelDisplay;
		
		private var numFormatter:NumberFormatter;
		public var shouldRun:Boolean = true;

		/**
		 * Constructor
		 */
		public function IncheckChart()
		{
		}
		
		
		// a function that can be passed in to convert the x values of chart data to another unit. Default is no conversion, just return the value.
		public var xConversionFunction:Function = function(value:Number):Number
		{
			return value
		}
				
		
		// a function that can be passed in to convert the y values of chart data to another unit. Default is no conversion, just return the value.
		public var yConversionFunction:Function = function(value:Number):Number
		{
			return value
		}
		
		
		public function initChart(_id:Object, chartType:String):void
		{
			this._chartType = chartType;
			this.id = String(_id);
			this._chartName = "Channel " + (id as String) + "::" + com.incheck.IncheckDataProvider.getChartName(chartType);

			showDataTips = true;
			// Define the vertical axis.
			var vAxis:CustomLinearAxis = new CustomLinearAxis();			
			verticalAxis = vAxis;
			// Horizontal axis
			var xAxis:CustomLinearAxis = new CustomLinearAxis();
			horizontalAxis = xAxis;
			
			series = getSeries();	
			numFormatter = new NumberFormatter();
			numFormatter.precision = 3;
		}
				
		public function get chartType():String
		{
			return _chartType;
		}
		
		public function get chartName():String
		{
			return _chartName;
		}
								
		public function isSpectrumType():Boolean
		{
			return false;
		}						
		
		public function resultHandler(event:ResultEvent):void
		{
			if (event.result == null)
			{
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
				dataPoint.y = yConversionFunction(dataPoint.y);
				newArr[i] = dataPoint;
			}
			
			var lastDataPoint:ChartDataPointVO = newArr[l - 1];
			lastDataPointY = lastDataPoint.y;
			
			if (lastDataPoint.bufferSize > 0)
			{
				//(this.horizontalAxis as LinearAxis).maximum=0;
				//(this.horizontalAxis as LinearAxis).minimum=(newArr[newArr.length-1].bufferSize * -1);		
			}
			dataProvider.source = newArr;
			
			// chartDP.source=newArr;

			if (chDisplayObj != null)
			{
//				chDisplayObj.rms.text = "" + numFormatter.format(lastDataPointY);
//				chDisplayObj.title = pData.dateTimeStamp;
			}
			if (shouldRun)
			{
				setTimeout(this.register, 5000);
			}			
		}
		
		public function faultHandler(event:FaultEvent):void
		{
			//Alert.show(event.fault.faultString, 'Fault Error');
		}
		 
		/**
		 * Registers current chart
		 */
		public function register():RemoteObject
		{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, resultHandler);
			ro.addEventListener("fault", faultHandler);
			ro.getProcessedDataObj(new Number(id), _chartType, "0");	
			trace("ro.getProcessedDataObj(" + id + ", " + _chartType + ", 0)");					
			return ro;
			return null;
		}			
		
		/**
		 * Returns series of charts points. If data with given id exists
		 * then method uses <code>Dictionary</code> to find it. In other case method
		 * creates an <code>Array</code> and push its to the Dictionary.
		 */
		private function getSeries():Array
		{
			var cd:com.incheck.ChartData = com.incheck.IncheckDataProvider.instance().getChartData(id, chartType);
		  	var mySeries:Array = new Array();
		  	var ls:LineSeries = cd.lineSeries;
		  	ls.xField = 'x';
		  	ls.yField = 'y';
		  	setChartProperties(ls);			
			mySeries.push(ls);
			dataProvider = cd.arrayCollection;
			
			var stroke:SolidColorStroke;
			
			// (this.horizontalAxis as NumericAxis).baseAtZero=true
			ls = new LineSeries();
			ls.displayName = "threshold sev 1Up";
			stroke= new Stroke();
			stroke.weight = 1;
			stroke.color = 0xFFCC00;
			stroke.joints = "bevel";
			
		  	ls.xField = 'x';
		  	ls.yField = 'sev1Upper';
			ls.setStyle("lineStroke", stroke);
			ls.toolTip = "";
			mySeries.push(ls);
			/* 
				public Double sev1Upper;
				public Double sev1Lower;
				public Double sev2Upper;
				public Double sev2Lower;
			 */
			
			ls = new LineSeries();
			ls.displayName = "threshold sev 1Low";
			stroke = new Stroke();
			stroke.weight = 1;
			stroke.color = 0x0033ff;
			stroke.joints = "bevel";
			
		  	ls.xField = 'x';
		  	ls.yField = 'sev1Lower';
			ls.setStyle("lineStroke", stroke);
			ls.toolTip = "";
			mySeries.push(ls);
			
			
			ls = new LineSeries();
			ls.toolTip = "";
			ls.displayName = "threshold sev 2Up";
			stroke = new Stroke();
			stroke.weight = 1;
			stroke.color = 0xFF0000;
			stroke.joints = "bevel";
		  	ls.xField = 'x';
		  	ls.yField = 'sev2Upper';
			ls.setStyle("lineStroke", stroke);
			mySeries.push(ls);
			
			ls = new LineSeries();
			ls.toolTip = "";
			ls.displayName = "threshold sev 2Low";
			stroke = new Stroke();
			stroke.weight = 1;
			stroke.color = 0x660099;
			stroke.joints = "bevel"
		  	ls.xField = 'x';
		  	ls.yField = 'sev2Lower';
			ls.setStyle("lineStroke", stroke);
			mySeries.push(ls);
			
			return mySeries;
		}
		
		public function changeChartType(chartType:String):void
		{
		}
		
		/**
		 * Sets chart properties (Stroke @see Stroke, LineRenderer, etc.)
		 * @param ls - LineSeries 
		 */
		private function setChartProperties(ls:LineSeries):void
		{
			var stroke:SolidColorStroke = new SolidColorStroke();
			switch (chartType)
			{
				case com.incheck.IncheckConstants.CHART_TYPE_SPECTRUM_A:
				case com.incheck.IncheckConstants.CHART_TYPE_SPECTRUM_V:
				case com.incheck.IncheckConstants.CHART_TYPE_SPECTRUM_D:
					stroke.weight = 1;
					stroke.color = 0x33FF00;
					stroke.joints = "mitter";
					break;
				case com.incheck.IncheckConstants.CHART_TYPE_TREND:
					break;
				case com.incheck.IncheckConstants.CHART_TYPE_WAVEFORM:
					stroke.weight = 1;
					stroke.color = 0x0033FF;
					stroke.joints = "bevel";
					break;
			}				
			ls.setStyle("lineStroke", stroke);
			// --- removing shade ---
			this.seriesFilters = [];
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{               
           	super.updateDisplayList(unscaledWidth, unscaledHeight);
           	trace("updateDisplayList");
        }
	}
}