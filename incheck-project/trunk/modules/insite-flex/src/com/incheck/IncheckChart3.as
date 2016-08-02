package com.incheck
{
	import com.incheck.charts.RangeSelector;
	import com.incheck.common.ChartUtils;
	import com.incheck.common.DataViewScalingTypes;
	import com.incheck.common.Logger;
	import com.incheck.components.ChannelWidget;
	import com.incheck.components.CustomLinearAxis;
	import com.incheck.components.RightNavigator;
	import com.incheck.components.events.InCheckEvent;
	
	import mx.charts.AxisRenderer;
	import mx.charts.HitData;
	import mx.charts.LineChart;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.AxisBase;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;

	public class IncheckChart3 extends LineChart implements IIncheckChart
	{
		private var lastColorUsed:int = -1;
        
		[Bindable]
		public var ymax:Number = Number.NEGATIVE_INFINITY;
		[Bindable]
		public var ymin:Number = Number.POSITIVE_INFINITY;
		[Bindable]
		public var xmin:Number = Number.POSITIVE_INFINITY;
		[Bindable]
		public var xmax:Number = Number.NEGATIVE_INFINITY;
		[Bindable]
		public var numCharts:int;

		private var xConversionSymbol:String;
		private var yConversionSymbol:String;
		
		// a function to convert the x values of chart data to another unit. Default is no conversion, just return the value.
		private var xConversionFunction:Function = function(value:Number):Number{return value};
		
		// a function to convert the y values of chart data to another unit. Default is no conversion, just return the value.
		private var yConversionFunction:Function = function(value:Number):Number{return value};
				        
		public function IncheckChart3()
		{
			super();
			this.setStyle("top", 5);
			this.setStyle("bottom", 5);
			this.setStyle("left", 5);
			this.setStyle("right", 5);
			this.showDataTips = true;
			
			this.dataTipFunction = dataTipsFunc;
			
			this.series = new Array();
			this.verticalAxis = new CustomLinearAxis();
			(this.verticalAxis as CustomLinearAxis).autoAdjust = false;
			(this.verticalAxis as CustomLinearAxis).labelFunction = labelFormatter;
			var verAxRend:AxisRenderer = new AxisRenderer();
			verAxRend.axis = this.verticalAxis;
			verAxRend.setStyle("verticalAxisTitleAlignment", "vertical");
			this.verticalAxisRenderers = [verAxRend];
			this.horizontalAxis = new CustomLinearAxis();
			(this.horizontalAxis as CustomLinearAxis).autoAdjust = false;
			(this.horizontalAxis as CustomLinearAxis).labelFunction = labelFormatter;
			this.seriesFilters = [];
		}
		
        private function getNextColor():uint
        {
			var colorsArray:Array = Constants.colorsArray;
        	if (lastColorUsed >= (colorsArray.length - 1))
        	{
        		lastColorUsed = 0;
        	}
        	else
        	{
      			lastColorUsed++;
        	}
        	return colorsArray[lastColorUsed] as uint;
        }
        
		public function resetVerticalZoom():void
		{
			var newymax:Number = Number.NEGATIVE_INFINITY;
			var newymin:Number = Number.POSITIVE_INFINITY;
			var hAx:CustomLinearAxis = this.horizontalAxis as CustomLinearAxis;
			
			for each (var ls:InCheckLineSeries in series)
			{
				for each (var o:Object in ls.dataProvider) {
					if(o.x <= hAx.maximum && o.x >= hAx.minimum){ // point is visible on chart
						if (o.y > newymax)
							newymax = o.y;
						if (o.y < newymin)
							newymin = o.y;
					}
				}
				
				ymax = newymax;
				ymin = newymin;
			}
			setMaxAxisValue();//vAx.maximum = ymax;
			setMinAxisValue();//vAx.minimum = ymin;
		}
		
		public function resetHorizontalZoom():void
		{
			var newxmax:Number = Number.NEGATIVE_INFINITY;
			var newxmin:Number = Number.POSITIVE_INFINITY;
			var hAx:CustomLinearAxis = this.horizontalAxis as CustomLinearAxis;
	
			for each (var ls:InCheckLineSeries in series)
			{
				for each (var o:Object in ls.dataProvider) {
					if (o.x > newxmax)
						newxmax = o.x;
					if (o.x < newxmin)
						newxmin = o.x;
				}
				
				xmax = newxmax;
				xmin = newxmin;
			}
			
			hAx.maximum = xmax;
			hAx.minimum = xmin;
		}

		public function regenLineSeriesWithZoomReset():void
		{
            Logger.log(this, "Regenerate Line series with zoomer reset");
			setupConversion();
			regenLineSeries();
			
			//don't redraw axes for for HZoom, VZoom, Pan
			if (IncheckModel.instance().scalingMenuSelection != DataViewScalingTypes.HZoom && 
				IncheckModel.instance().scalingMenuSelection != DataViewScalingTypes.VZoom && 
				IncheckModel.instance().scalingMenuSelection != DataViewScalingTypes.Pan){ 
				this.resetHorizontalZoom();
				this.resetVerticalZoom();
			}
		}
		
		public function setupConversion():void
		{
			// the x-axis title is determined by what units are selected in the menubar.  Then we get the correct unit conversion function that will convert the chartdata's default units from the ChannelWidget
			if (IncheckModel.instance().functionMenuSelection == "wave")
			{
				switch (IncheckModel.instance().TimeEUnit)
				{
					case "TimeMiliSec" :
					{
						xConversionSymbol = "ms";
						break;
					}
					default :
					{
						xConversionSymbol = "s";
						break;						
					}
				}
				xConversionFunction = IncheckModel.instance().getTimeUnitsConversionFunction(xConversionSymbol);
			}
			else if (IncheckModel.instance().functionMenuSelection == "spec")
			{
				switch (IncheckModel.instance().FreqEUnit)
				{
					case "FreqCPM" :
					{
						xConversionSymbol = "CPM";
						break;
					}
					default :
					{
						xConversionSymbol = "Hz";
						break;						
					}
				}	
				xConversionFunction = IncheckModel.instance().getFrequencyUnitsConversionFunction(xConversionSymbol);			
			}
			// the y-axis title is determined by what units are selected in the menubar.  Then we get the correct unit conversion function that will convert the chartdata's default units from the ChannelWidget
			if (IncheckModel.instance().graphMenuSelection == "accel")
			{
				switch (IncheckModel.instance().AccEUnit)
				{
					case "AccInSec2" :
					{
						yConversionSymbol =  "in/s²";
						break;
					}
					case "AccMtrPerSec2" :
					{
						yConversionSymbol =  "m/s²";
						break;
					}
					case "AccMmSec2" :
					{
						yConversionSymbol =  "mm/s²";
						break;
					}	
					case "AccDb" :
					{
						yConversionSymbol =  "dB";
						break;
					}						
					default :
					{
						yConversionSymbol =  "g";
						break;
					}
				}
				yConversionFunction = IncheckModel.instance().getAccelerationUnitsConversionFunction(yConversionSymbol);						
			}
			else if (IncheckModel.instance().graphMenuSelection == "velo")
			{
				switch (IncheckModel.instance().VelEUnit)
				{
					case "VelMtrSec" :
					{
						yConversionSymbol =  "m/s";
						break;
					}
					case "VelMmSec" :
					{
						yConversionSymbol =  "mm/s";
						break;
					}	
					case "VelDb" :
					{
						yConversionSymbol =  "dB";
						break;
					}							
					default :
					{
						yConversionSymbol =  "in/s";
						break;
					}
				}
				yConversionFunction = IncheckModel.instance().getVelocityUnitsConversionFunction(yConversionSymbol);							
			}			
		}
		
		
		
		public function regenLineSeries():void
		{
            Logger.log(this, "Regenerate line series");
			var allWidg:Array = IncheckModel.instance().left.selectedChannelsBox.getChildren();
			
			reorganizeWidgets(allWidg);
			
			numCharts = allWidg.length;
			this.series = new Array();
			var firstOne:Boolean = true;
			for each (var oneW:ChannelWidget in allWidg)
			{
				if ((!oneW.chBox.selected ) || oneW.graphData == null || oneW.graphData.chartData == null)
				{
					continue;
				}
				var ls:InCheckLineSeries = new InCheckLineSeries();
				ls.filterData = false;
				ls.node = oneW.node;
				//ls.displayName=oneW.processedData.measurementUnit;	
				
				if (firstOne)
				{
					firstOne = false;
					(this.horizontalAxis as CustomLinearAxis).title = xConversionSymbol;
					(this.verticalAxis as CustomLinearAxis).title = yConversionSymbol;
					if (IncheckModel.instance().functionMenuSelection == "spec")
						(this.verticalAxis as CustomLinearAxis).title += " " + IncheckModel.instance().MesType;
				}
				//Alert.show(ObjectUtil.toString(oneW.processedData));
				
				if (oneW.graphData.measurementUnit == "ms" || oneW.graphData.measurementUnit == "s")
				{
					var currentMax:Number = ymax;//(this.verticalAxis as LinearAxis).maximum;
					var waveFormMax:Number = Math.abs(yConversionFunction(oneW.graphData.max));
					var minValueAbs:Number = Math.abs(yConversionFunction(oneW.graphData.min));
					if (minValueAbs > waveFormMax)
					{
						waveFormMax = minValueAbs;
					}
					if (waveFormMax > currentMax)
					{
//						(this.verticalAxis as LinearAxis).maximum = waveFormMax;
//						(this.verticalAxis as LinearAxis).minimum = -waveFormMax;
						ymax = waveFormMax;
						ymin = -waveFormMax;
						setMaxAxisValue();
						setMinAxisValue();
						//Alert.show("adjusted waveform min/max to "+(this.verticalAxis as LinearAxis).maximum+"\t"+(this.verticalAxis as LinearAxis).minimum);
					}
				}

				var stroke:SolidColorStroke = new SolidColorStroke();
				stroke.weight = 1;
				stroke.joints = "bevel";
				if (oneW.myColorSet == uint.MAX_VALUE)
				{
					oneW.myColorSet = getNextColor();
				}
				stroke.color = oneW.myColorSet;
				ls.setStyle("lineStroke", stroke);
				
				// convert to the selected units
				var convertedChartData:ArrayCollection = new ArrayCollection();
				var n:int = oneW.graphData.chartData.length;
				for (var i:int = 0; i < n; i++)
				{
					var chartData:Object = {};
					chartData.x = xConversionFunction(oneW.graphData.chartData[i].x);
					chartData.y = yConversionFunction(oneW.graphData.chartData[i].y);
					chartData.sev1Lower = oneW.graphData.chartData[i].sev1Lower;
					chartData.sev1Upper = oneW.graphData.chartData[i].sev1Upper;
					chartData.sev2Lower = oneW.graphData.chartData[i].sev2Lower;
					chartData.sev2Upper = oneW.graphData.chartData[i].sev2Upper;
					chartData.buffersize = oneW.graphData.chartData[i].bufferSize;
					convertedChartData.addItemAt(chartData, i);
				}				
				
				ls.dataProvider = convertedChartData;
				ls.xField = 'x';
				ls.yField = 'y';
				this.series[this.series.length] = ls;
			}

			for each (var eachRend:AxisRenderer in this.verticalAxisRenderers)
			{
				eachRend.axis = this.verticalAxis;
				eachRend.setStyle("verticalAxisTitleAlignment", "vertical");
			}
			this.invalidateData();
			this.invalidateSeries();
			this.validateNow();
			//dispatchEvent(new InCheckEvent(InCheckEvent.CREATE_SCREEN));
		}
		
		private function labelFormatter(val:Object, pval:Object, ax:AxisBase):String {
			if (val is Number){
				return RangeSelector.toScientific(val as Number);
			}
			return val.toString();
		}
		
		private function reorganizeWidgets(widgets:Array):void {
			var found:Boolean = false;
			var i:uint = 0;
			while (!found && i < widgets.length){
				var widg:ChannelWidget = widgets[i];
				if (widg.selected) {
					found = true;
					widgets.splice(i, 1);
					widgets.push(widg);
				}
				i++;
			}
		}
		
		public function dataTipsFunc(event:HitData):String {
			var tip:String = "";
			var item:Object = event.chartItem.item;
			
			tip = RangeSelector.toScientific(item.y) + " " + yConversionSymbol;
			if (IncheckModel.instance().functionMenuSelection == "spec") {
				tip += " " + IncheckModel.instance().MesType;
			}
			tip += "\n" + RangeSelector.toScientific(item.x) + " " + xConversionSymbol;
			
			return tip;
		}
		
		private function setMaxAxisValue():void {
			if(ymax != Number.NEGATIVE_INFINITY){
				if ((IncheckModel.instance().right as RightNavigator).autoscale.selected) {
					(this.verticalAxis as CustomLinearAxis).maximum = ymax*1.2;
				} else {
					(this.verticalAxis as CustomLinearAxis).maximum = ChartUtils.getMaxValue(ymax,0.8); 
				}
			}
		}
		
		private function setMinAxisValue():void {
			if(ymin != Number.POSITIVE_INFINITY){
				if (IncheckModel.instance().functionMenuSelection == "wave") {
					if ((IncheckModel.instance().right as RightNavigator).autoscale.selected) {
						(this.verticalAxis as CustomLinearAxis).minimum = ymin*1.2;
					} else {
						(this.verticalAxis as CustomLinearAxis).minimum = ChartUtils.getMinValue(ymin,-0.8);
					}
				} else {
					(this.verticalAxis as CustomLinearAxis).minimum = ymin;
				}
			}
		}
		
		public function changeScale():void {
			setMaxAxisValue();
			setMinAxisValue();
		}
		
		public function clearData():void
		{
			this.series = new Array();
			this.verticalAxis = new CustomLinearAxis();
			(this.verticalAxis as CustomLinearAxis).autoAdjust = true;
			var verAxRend:AxisRenderer = new AxisRenderer();
			verAxRend.axis = this.verticalAxis;
			this.horizontalAxis = new CustomLinearAxis();
			(this.horizontalAxis as CustomLinearAxis).autoAdjust = true;
			for each (var eachRend:AxisRenderer in this.verticalAxisRenderers)
			{
				eachRend.axis = this.verticalAxis;
				eachRend.setStyle("verticalAxisTitleAlignment", "vertical");
			}
			this.invalidateData();
			this.invalidateSeries();
			this.validateNow();
		}
	}
}