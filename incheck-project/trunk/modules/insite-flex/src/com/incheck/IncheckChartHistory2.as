package com.incheck
{
	import com.incheck.charts.RangeSelectorHistory;
	import com.incheck.common.ChartUtils;
	import com.incheck.common.DataViewScalingTypes;
	import com.incheck.common.ICNode;
	import com.incheck.common.Logger;
	import com.incheck.components.ChannelHistoryWidget;
	import com.incheck.components.CustomLinearAxis;
	import com.incheck.components.FixedAxisRenderer;
	import com.incheck.components.RightNavigator;
	import com.incheck.components.events.InCheckEvent;
	
	import mx.charts.DateTimeAxis;
	import mx.charts.HLOCChart;
	import mx.charts.HitData;
	import mx.charts.events.ChartItemEvent;
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;
	
	public class IncheckChartHistory2 extends HLOCChart implements IIncheckChart
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
		
		private var _showMinMax:Boolean;
		
		private var vas:Array;
        
		public function IncheckChartHistory2() {
			super();
			this.addEventListener(ChartItemEvent.ITEM_CLICK, itemClickHand);
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
			this.verticalAxis = new CustomLinearAxis();
			(this.verticalAxis as CustomLinearAxis).autoAdjust = false;
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
		
		public function regenLineSeriesWithZoomReset():void {
			setupConversion();
			regenStockSeries();
			resetVerticalZoom();
		}
		
		public function setupConversion():void {
			yAccConversionSymbol = IncheckModel.instance().histAccEUnit;
			yVelConversionSymbol = IncheckModel.instance().histVelEUnit;
			if (IncheckModel.instance().historyGraphMenuSelection.indexOf("Accel") > -1){
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
			for each(var vAx:CustomLinearAxis in vas){
				if(IncheckModel.instance().scalingHistoryMenuSelection != DataViewScalingTypes.VZoom ||
					(IncheckModel.instance().scalingHistoryMenuSelection == DataViewScalingTypes.VZoom && !vAx.isZoomed)){ //if it is not vzoomed axis
					var newymax:Number = Number.NEGATIVE_INFINITY;
					var newymin:Number = Number.POSITIVE_INFINITY;
					
					for each (var ss:InCheckStockSeries in series)  {
						
						if(ss.verticalAxis == vAx){
							for each (var o:Object in ss.dataProvider) {
								if (o.maxValue > newymax)
									newymax = o.maxValue;
								if (o.minValue < newymin)
									newymin = o.minValue;
							}
						}
					}
					ymax = newymax;
					ymin = newymin;
					
					var defaultMax:Number;
					if(vAx.overallType == "T")
						defaultMax = 80;
					else
						defaultMax = 0.8;
					
					setAxisValues(vAx, defaultMax);
				}
			}
			updateScreen();
		}
		
		private function setAxisValues(vAx:CustomLinearAxis, defaultMax:Number):void {
			if ((IncheckModel.instance().right as RightNavigator).historyViewMenuBar.autoScale.toggled) {
				ymin -= 0.2 * (ymax - ymin);
				ymax += 0.2 * (ymax - ymin);	
				vAx.maximum = ymax;
				vAx.minimum = ymin;
			} else {
				vAx.maximum = ChartUtils.getMaxValue(ymax,defaultMax);
				vAx.minimum = 0;
			}
		}
		
		public function clearSeriesZoomFlag():void{
			if(vas){
				for each(var vAx:CustomLinearAxis in vas){
					vAx.isZoomed = false;
				}
			}
		}
		
		public function regenStockSeries():void {
            Logger.log(this, "Regenerate stock series");
			var allWidg:Array = IncheckModel.instance().left.selectedHistoryBox.getChildren();
			numCharts = allWidg.length;
			var mySeries:Array = [];
			this.verticalAxisRenderers = [verticalAxisRenderers[0]];
			vas = [];
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
					if (ss.overallType.indexOf("Band") > -1 && IncheckModel.instance().historyParameter == "Peak") {   
						ss.dataProvider = convertRMStoPeak(ss.dataProvider as ArrayCollection);//get Peak values for channels with all bands axcept "Overall" 
														//(for "Overall" bands data comes right from server)
					}
				} else if (oneW.node.channelType == Constants.STATIC_CHANNEL) {
					if (ss.overallType == "T") {
						ss.dataProvider = updateSeries(oneW.histData, yTempConversionFunction);
					} else if (ss.overallType == "P") {
						ss.dataProvider = updateSeries(oneW.histData, yPressConversionFunction);
					}
				}
				ss.node = oneW.node;
				mySeries.push(ss);
				
				var shortOverallType:String = ss.overallType.slice(0,3).toLowerCase();
				if (usedTypes.indexOf(shortOverallType) == -1) { //create new CustomLinearAxis
					usedTypes.push(shortOverallType);
					axisIndex = vas.length;
					if (axisIndex) {
						var va:CustomLinearAxis = new CustomLinearAxis();
						va.autoAdjust = false;
						var rend:FixedAxisRenderer = new FixedAxisRenderer();
						rend.setStyle("verticalAxisTitleAlignment", "vertical");
						rend.axis = va;
						verticalAxisRenderers.push(rend);
						vas.push(va);
					} else {
						vas.push(this.verticalAxis);
					}
					
					if((vas[axisIndex] as CustomLinearAxis).overallType != ss.overallType){
						(vas[axisIndex] as CustomLinearAxis).overallType = ss.overallType;
						(vas[axisIndex] as CustomLinearAxis).isZoomed = false;
					}
					
					if (oneW.node.channelType == Constants.DYNAMIC_CHANNEL) {
						var histEUnit:String = IncheckModel.instance().historyGraphMenuSelection.indexOf("Accel") > -1 ? IncheckModel.instance().histAccEUnit : IncheckModel.instance().histVelEUnit; 
						(vas[axisIndex] as CustomLinearAxis).title = histEUnit + " " + IncheckModel.instance().historyParameter;
					} else if (oneW.node.channelType == Constants.STATIC_CHANNEL) {
						if (ss.overallType == "T") {
							(vas[axisIndex] as CustomLinearAxis).title = yTempConversionSymbol;
						} else if (ss.overallType == "P") {
							(vas[axisIndex] as CustomLinearAxis).title = yPressConversionSymbol;
						}
					}
				}else{
					axisIndex = usedTypes.indexOf(shortOverallType); //find proper linearAxis
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
		}
		
		private function updateScreen():void{
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
		
		private function convertRMStoPeak(histData:ArrayCollection):ArrayCollection {
			for each (var obj:Object in histData) {
				for (var prop:String in obj){
					if(obj[prop] is Number){
						obj[prop] = obj[prop]*Math.SQRT2;
					}
				}
			}
			return histData;
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
				if (IncheckModel.instance().historyGraphMenuSelection.indexOf("Accel") > -1){
					tip += yAccConversionSymbol + " " + IncheckModel.instance().historyParameter;
				} else {
					tip += yVelConversionSymbol + " " + IncheckModel.instance().historyParameter;
				}
				
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