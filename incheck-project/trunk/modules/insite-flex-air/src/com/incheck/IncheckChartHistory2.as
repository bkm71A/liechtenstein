package com.incheck
{
	import com.incheck.charts.RangeSelectorHistory;
	import com.incheck.common.ICNode;
	import com.incheck.common.Logger;
	import com.incheck.components.ChannelHistoryWidget;
	import com.incheck.components.FixedAxisRenderer;
	import com.incheck.components.events.InCheckEvent;
	
	import mx.charts.DateTimeAxis;
	import mx.charts.HLOCChart;
	import mx.charts.HitData;
	import mx.charts.LinearAxis;
	import mx.charts.events.ChartItemEvent;
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;
	
	public class IncheckChartHistory2 extends HLOCChart
	{	
		[Bindable]
		public var numCharts:int;
		[Bindable]
		public var ymax:Number = Number.NEGATIVE_INFINITY;
		[Bindable]
		public var ymin:Number = Number.POSITIVE_INFINITY;
		
		private var lastColorUsed:int = -1;
		
		private const HOUR_IN_MILLISECONDS:Number = 60 * 60 * 1000;
		private const DAY_IN_MILLISECONDS:Number = 24 * 60 * 60 * 1000;
		private const WEEK_IN_MILLISECONDS:Number = 7 * 24 * 60 * 60 * 1000;
		private const YEAR_IN_MILLISECONDS:Number = 365 * 24 * 60 * 60 * 1000;
		
        private var dateForm:DateFormatter = new DateFormatter();
		private var dateTimeForm:DateFormatter = new DateFormatter();
		private var timeForm:DateFormatter = new DateFormatter();
		private var timeSecForm:DateFormatter = new DateFormatter();
		private var numFormat:NumberFormatter = new NumberFormatter();
		
		private var yAccConversionSymbol:String;
		private var yVelConversionSymbol:String;
		private var yConversionFunction:Function = function(value:Number):Number{return value};
		private var yTempConversionSymbol:String;
		private var yTempConversionFunction:Function = function(value:Number):Number{return value};
		private var yPressConversionSymbol:String;
		private var yPressConversionFunction:Function = function(value:Number):Number{return value};
		
		private var _showMinMax:Boolean = true;
        
		public function IncheckChartHistory2() {
			super();
			this.addEventListener(ChartItemEvent.ITEM_CLICK, itemClickHand, false, 0, true);
			this.setStyle("top", 5);
			this.setStyle("bottom", 5);
			this.setStyle("left", 5);
			this.setStyle("right", 5);
			this.showDataTips = true;
			
			this.series = [];
			
			//formatting
			dateForm.formatString = "MM/DD/YY";
			dateTimeForm.formatString = "MM/DD/YY LL:NN:SS A";
			timeForm.formatString = "LL:NN A";
			timeSecForm.formatString = "LL:NN:SS A";
			numFormat.precision = 3;
			numFormat.rounding = NumberBaseRoundType.UP;
			
			this.dataTipFunction = dataTipsFunc;

			// horizontal axis
			horizontalAxis = new DateTimeAxis();
			(this.horizontalAxis as DateTimeAxis).displayLocalTime = true;
			(this.horizontalAxis as DateTimeAxis).labelFunction = dateLabelFormatter;
			
			// vertical axis
			this.verticalAxis = new LinearAxis();
			(this.verticalAxis as LinearAxis).autoAdjust = false;
			var verAxRend:FixedAxisRenderer = new FixedAxisRenderer();
		//verAxRend.
			verAxRend.axis = this.verticalAxis;
			verAxRend.setStyle("verticalAxisTitleAlignment", "vertical");
			this.verticalAxisRenderers = [verAxRend];
		}
		
		private function getNextColor():uint {
			var colorsArray:Array = Constants.colorsArray;
        	if (lastColorUsed >= (colorsArray.length - 1)){
        		lastColorUsed = 0;
        	} else {
      			lastColorUsed++;
        	}
        	return colorsArray[lastColorUsed] as uint;
        }
        
        public function dateRangeChanged():void {
			refreshData();
		}
		
		public function refreshData():void {
            this.series  = [];
			this.invalidateSeriesStyles();
			analyseDateRange();
			var allWidg:Array = IncheckModel.instance().left.selectedHistoryBox.getChildren();
			for each (var oneW:ChannelHistoryWidget in allWidg) {
				oneW.refreshData();
			}			
		}
		
		public function regenStockSeriesWithZoomReset():void {
			setupConversion();
			resetVerticalZoom();
			regenStockSeries();
		}
		
		public function setupConversion():void {
			yAccConversionSymbol = IncheckModel.instance().histAccEUnit;
			yVelConversionSymbol = IncheckModel.instance().histVelEUnit;
			if (IncheckModel.instance().getUserVibrationType().indexOf("Accel") > -1){
				yConversionFunction = IncheckModel.instance().getAccelerationUnitsConversionFunction(yAccConversionSymbol);		
			} else {
				yConversionFunction = IncheckModel.instance().getVelocityUnitsConversionFunction(yVelConversionSymbol);		
			}
			
			yTempConversionSymbol = IncheckModel.instance().histTempEUnit;
			yTempConversionFunction = IncheckModel.instance().getTemperatureUnitsConversionFunction(yTempConversionSymbol);		
			
			yPressConversionSymbol = IncheckModel.instance().histPressEUnit;
			yPressConversionFunction = IncheckModel.instance().getPressureUnitsConversionFunction(yPressConversionSymbol);		
		}
		
		public function resetVerticalZoom():void {
			var newymax:Number = Number.NEGATIVE_INFINITY;
			var newymin:Number = Number.POSITIVE_INFINITY;
			var allWidg:Array = IncheckModel.instance().left.selectedHistoryBox.getChildren();
			var vAx:LinearAxis = this.verticalAxis as LinearAxis;
			
			for each (var oneW:ChannelHistoryWidget in allWidg)  {
				if ((!oneW.chBox.selected) || oneW.histData == null) {
					continue;
				}
				
				for each (var o:Object in oneW.histData) {
					var convertedMax:Number = yConversionFunction(o.maxValue);
					if (convertedMax > newymax)
						newymax = convertedMax;
					var convertedMin:Number = yConversionFunction(o.minValue);
					if (convertedMin < newymin)
						newymin = convertedMin;
				}
			}
			ymax = newymax;
			ymin = newymin;
			
			ymin -= 0.02 * (ymax - ymin);
			ymax += 0.02 * (ymax - ymin);
			
			vAx.maximum = ymax;
			vAx.minimum = ymin;
		}
		
		public function regenStockSeries():void {
            Logger.log(this, "Regenerate stock series");
			var allWidg:Array = IncheckModel.instance().left.selectedHistoryBox.getChildren();
			numCharts = allWidg.length;
			var mySeries:Array = [];
			this.verticalAxisRenderers = [verticalAxisRenderers[0]];
			var vas:Array = [];
			var usedTypes:Array = [];
			var axisIndex:int = -1;
			
			for each (var oneW:ChannelHistoryWidget in allWidg) {
				if ((!oneW.chBox.selected) || oneW.histData == null) {
					continue;
				}
				
				if (oneW.myColorSet == uint.MAX_VALUE) {
					oneW.myColorSet = getNextColor();
				}
				
				var ss:InCheckStockSeries = new InCheckStockSeries();
				ss.updateColorSet(oneW.myColorSet);
				//trace ("hist data array lenght " + oneW.histData.length);
				if (oneW.histData.length > 0){
					ss.overallType = oneW.histData.getItemAt(0).overallType;
					//trace("overall type " + ss.overallType);
				}
				if (oneW.node.channelType == Constants.DYNAMIC_CHANNEL) {
					ss.dataProvider = updateSeries(oneW.histData, yConversionFunction);
				} else if (oneW.node.channelType == Constants.STATIC_CHANNEL) {
					if (ss.overallType == "T") {
						ss.dataProvider = updateSeries(oneW.histData, yTempConversionFunction);
					} else if (ss.overallType == "P") {
						ss.dataProvider = updateSeries(oneW.histData, yPressConversionFunction);
					}
				}
				ss.node = oneW.node;
				mySeries.push(ss);
				
				if (usedTypes.indexOf(ss.overallType) == -1) {
					usedTypes.push(ss.overallType);
					axisIndex = vas.length;
					if (axisIndex) {
						var va:LinearAxis = new LinearAxis();
						va.autoAdjust = false;
						var rend:FixedAxisRenderer = new FixedAxisRenderer();
						rend.setStyle("verticalAxisTitleAlignment", "vertical");
						rend.axis = va;
						verticalAxisRenderers.push(rend);
						vas.push(va);
					} else {
						vas.push(this.verticalAxis);
					}
					if (oneW.node.channelType == Constants.DYNAMIC_CHANNEL) {
						(vas[axisIndex] as LinearAxis).title = IncheckModel.instance().histAccEUnit + " " + IncheckModel.instance().historyParameter;
					} else if (oneW.node.channelType == Constants.STATIC_CHANNEL) {
						if (ss.overallType == "T") {
							(vas[axisIndex] as LinearAxis).title = yTempConversionSymbol;
						} else if (ss.overallType == "P") {
							(vas[axisIndex] as LinearAxis).title = yPressConversionSymbol;
						}
					}
				}
				ss.verticalAxis = vas[axisIndex];
				
//				var ls:LineSeries = new LineSeries();
//				var stroke:Stroke = new Stroke();
//				stroke.weight = 1;
//				stroke.joints = "bevel";
//				stroke.color = oneW.myColorSet;
//				ls.setStyle("lineStroke", stroke);
//				ls.dataProvider = ss.dataProvider;
//				ls.xField = 'x';
//				ls.yField = 'avgValue';
//				mySeries.push(ls);
			}
			
			if (mySeries.length > 0) {
				this.dataProvider = (mySeries[0] as InCheckStockSeries).dataProvider;
			}
			
			
			var fromTime:Number = IncheckModel.instance().right.historyViewMenuBar.fromDate.getTime();
			var toTime:Number = IncheckModel.instance().right.historyViewMenuBar.toDate.getTime();
			
			var minAx:Date = new Date(fromTime - 0.02 * (toTime - fromTime));
			var maxAx:Date = new Date(toTime + 0.02 * (toTime - fromTime));
			
			(this.horizontalAxis as DateTimeAxis).minimum = minAx;
			(this.horizontalAxis as DateTimeAxis).maximum = maxAx;
			(this.horizontalAxis as DateTimeAxis).labelUnits = IncheckModel.instance().historyChartUnits;
			(this.horizontalAxis as DateTimeAxis).dataUnits = IncheckModel.instance().historyChartUnits;
			
			//(this.verticalAxis as LinearAxis).maximum = 0.475;
			//(this.verticalAxis as LinearAxis)
			
			
			this.series = mySeries;
			this.invalidateSeriesStyles();

			this.invalidateData();
			this.invalidateSeries();
			this.validateNow();	
			dispatchEvent(new InCheckEvent(InCheckEvent.CREATE_SCREEN));
		}
		
		private function analyseDateRange():void {
			var fromDate:Date = IncheckModel.instance().right.historyViewMenuBar.fromDate;
			var toDate:Date = IncheckModel.instance().right.historyViewMenuBar.toDate;
			
			// determine date range 
			if (fromDate && toDate) {
				var dateRange:Number = toDate.getTime() - fromDate.getTime();
				// if date range is wider than one year show weekly spreads 
				if (dateRange - (YEAR_IN_MILLISECONDS) >= 0) {
					IncheckModel.instance().historyChartUnits = Constants.WEEKS;
					// if date range is wider than one week show daily spreads 
				} else if (dateRange - (WEEK_IN_MILLISECONDS) >= 0) {
					IncheckModel.instance().historyChartUnits = Constants.DAYS;
					// if date range is wider than one day show hourly spreads 
				} else if (dateRange - (DAY_IN_MILLISECONDS) >= 0) {
					IncheckModel.instance().historyChartUnits = Constants.HOURS;
				} else {
					IncheckModel.instance().historyChartUnits = Constants.SECONDS;
				}
			}
		}
		
		private function updateSeries(histData:ArrayCollection, conversionFunction:Function):ArrayCollection {
			var historyData:ArrayCollection = new ArrayCollection();
			var obj:Object = {};
			var newObj:Object = {};
			for each (obj in histData) {
				newObj = {};
				newObj.x = obj.x;
				if (_showMinMax) {
					newObj.minValue = conversionFunction(obj.minValue);
					newObj.maxValue = conversionFunction(obj.maxValue);
					newObj.avgValue = conversionFunction(obj.avgValue);
				} else {
					newObj.minValue = newObj.maxValue = newObj.avgValue = conversionFunction(obj.avgValue);
				}
				historyData.addItem(newObj);
			}
			return historyData;
		}
		
		public function clearData():void {
			this.series = new Array();
			this.invalidateData();
			this.invalidateSeries();
			this.validateNow();	
		}
		
		public function itemClickHand(event:ChartItemEvent):void {
			// Alert.show((event.hitData.element as InCheckLineSeries).node.channelid );
			// Alert.show((event.hitData as HitData).item.x);
            if (RangeSelectorHistory.haveWeZoomed) return;
            if (event.hitData == null) return;
			var date:Date;
			
			var units:String = IncheckModel.instance().historyChartUnits;
			switch (units) {
				case Constants.WEEKS:
					date = new Date((event.hitData.item.x as Date).getTime());
					date.date += 7;
					IncheckModel.instance().right.historyViewMenuBar.updateDateRanges(event.hitData.item.x, date); 
					break;
				case Constants.DAYS:
					date = new Date((event.hitData.item.x as Date).getTime());
					date.date += 1;
					IncheckModel.instance().right.historyViewMenuBar.updateDateRanges(event.hitData.item.x, date); 
					break;
				case Constants.HOURS:
					date = new Date((event.hitData.item.x as Date).getTime());
					date.hours += 1;
					IncheckModel.instance().right.historyViewMenuBar.updateDateRanges(event.hitData.item.x, date); 
					break;
				case Constants.SECONDS:
					if ((event.hitData.element as InCheckStockSeries).node.channelType == 1) {
                        Logger.log(this, "Add chart from history");
                        IncheckModel.instance().addChart((event.hitData.element as InCheckStockSeries).node, event.hitData.item.x as Date)
					}
					break;
				default:
					break;
			}
		}
		
		public function dataTipsFunc(event:HitData):String {
			var tip:String = "";
			var item:Object = event.chartItem.item;
			var currSeries:InCheckStockSeries = (event.element as InCheckStockSeries);
			var node:ICNode = currSeries.node;
			tip = numFormat.format(item.avgValue) + " ";
			if (node.channelType == Constants.DYNAMIC_CHANNEL) {
				tip += yAccConversionSymbol + " " + IncheckModel.instance().historyParameter;
			} else if (node.channelType == Constants.STATIC_CHANNEL) {
				if (currSeries.overallType == "T") {
					tip += yTempConversionSymbol;
				} else if (currSeries.overallType == "P") {
					tip += yPressConversionSymbol;
				}
			}
			tip += "\n";
			if (IncheckModel.instance().historyChartUnits == Constants.HOURS ||
				IncheckModel.instance().historyChartUnits == Constants.SECONDS) {
				tip += dateTimeForm.format(item.x);
			} else {
				tip += dateForm.format(item.x);
			}
			return tip;
		}	
		
		private function dateLabelFormatter(val:Object, pval:Object, ax:DateTimeAxis):String {
			if (ax.labelUnits == Constants.DAYS || ax.labelUnits == Constants.WEEKS) {
				return dateForm.format(val);
			} else if (ax.labelUnits == Constants.HOURS) {
				return timeForm.format(val);
			} else if (ax.labelUnits == Constants.SECONDS) {
				return timeSecForm.format(val);
			} 
			return val.toString();
		} 
		
		public function set showMinMax(value:Boolean):void {
			if (_showMinMax != value){
				_showMinMax = value;
				regenStockSeries();
			}
		}
		
		public function get showMinMax():Boolean {
			return _showMinMax;
		}
		
	}
}