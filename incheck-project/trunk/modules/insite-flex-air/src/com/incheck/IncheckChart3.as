package com.incheck
{
	import com.degrafa.geometry.display.IDisplayObjectProxy;
	import com.incheck.charts.RangeSelectorAnalysis;
	import com.incheck.common.ICNode;
	import com.incheck.components.ChannelWidget;
	import com.incheck.components.RightNavigator;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.charts.AxisRenderer;
	import mx.charts.HitData;
	import mx.charts.LineChart;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.AxisBase;
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElementContainer;
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
			this.verticalAxis = new LinearAxis();
			(this.verticalAxis as LinearAxis).autoAdjust = false;
			(this.verticalAxis as LinearAxis).labelFunction = labelFormatter;
			var verAxRend:AxisRenderer = new AxisRenderer();
			verAxRend.axis = this.verticalAxis;
			verAxRend.setStyle("verticalAxisTitleAlignment", "vertical");
			this.verticalAxisRenderers = [verAxRend];
			this.horizontalAxis = new LinearAxis();
			(this.horizontalAxis as LinearAxis).autoAdjust = false;
			(this.horizontalAxis as LinearAxis).labelFunction = labelFormatter;
			this.seriesFilters = [];
		}


		// a function to convert the x values of chart data to another unit. Default is no conversion, just return the value.
		private var xConversionFunction:Function = function(value:Number):Number
		{
			return value;
		}

		// a function to convert the y values of chart data to another unit. Default is no conversion, just return the value.
		private var yConversionFunction:Function = function(value:Number):Number
		{
			return value;
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


		private function getWidgets(container:DisplayObjectContainer):Array
		{
			var widgets:Array = new Array();
			var l:int = container.numChildren;
			for (var i:int = 0; i < l; i++)
			{
				widgets.push(container.getChildAt(i));
			}
			return widgets;
		}
		
		
		public function resetVerticalZoom():void
		{
			var newymax:Number = Number.NEGATIVE_INFINITY;
			var newymin:Number = Number.POSITIVE_INFINITY;
			var allWidg:Array = getWidgets(IncheckModel.instance().left.analysisWidgets);
			var vAx:LinearAxis = this.verticalAxis as LinearAxis;

			for each (var oneWZ:ChannelWidget in allWidg)
			{
				if ((!oneWZ.showGraphOption.selected) || oneWZ.graphData == null)
				{
					continue;
				}

				for each (var o:Object in oneWZ.graphData.chartData)
				{
					var convertedY:Number = yConversionFunction(o.y);
					if (convertedY > newymax)
						newymax = convertedY;
					if (convertedY < newymin)
						newymin = convertedY;
				}
			}
			ymax = newymax;
			ymin = newymin;
			setMaxAxisValue(); //vAx.maximum = ymax;
			setMinAxisValue(); //vAx.minimum = ymin;
		}


		public function resetHorizontalZoom():void
		{
			var newxmax:Number = Number.NEGATIVE_INFINITY;
			var newxmin:Number = Number.POSITIVE_INFINITY;
			var allWidg:Array = getWidgets(IncheckModel.instance().left.analysisWidgets);
			var hAx:LinearAxis = this.horizontalAxis as LinearAxis;

			for each (var oneWZ:ChannelWidget in allWidg)
			{
				if ((!oneWZ.showGraphOption.selected) || oneWZ.graphData == null)
				{
					continue;
				}
				for each (var o:Object in oneWZ.graphData.chartData)
				{
					var convertedX:Number = xConversionFunction(o.x)
					if (convertedX > newxmax)
						newxmax = convertedX;
					if (convertedX < newxmin)
						newxmin = convertedX;
				}
			}
			xmax = newxmax;
			xmin = newxmin;
			hAx.maximum = xmax;
			hAx.minimum = xmin;
			//resetVerticalZoom();
		}


		public function regenLineSeriesWithZoomReset():void
		{
//            Logger.log(this, "Regenerate Line series with zoomer reset");
			setupConversion();
			this.resetHorizontalZoom();
			this.resetVerticalZoom();
			regenLineSeries();
		}


		public function setupConversion():void
		{
			// the x-axis title is determined by what units are selected in the menubar.  Then we get the correct unit conversion function that will convert the chartdata's default units from the ChannelWidget
			if (IncheckModel.instance().functionMenuSelectionAnalysis == "wave")
			{
				switch (IncheckModel.instance().TimeEUnit)
				{
					case "TimeMiliSec":
					{
						xConversionSymbol = "ms";
						break;
					}
					default:
					{
						xConversionSymbol = "s";
						break;
					}
				}
				xConversionFunction = IncheckModel.instance().getTimeUnitsConversionFunction(xConversionSymbol);
			}
			else if (IncheckModel.instance().functionMenuSelectionAnalysis == "spec")
			{
				switch (IncheckModel.instance().FreqEUnit)
				{
					case "FreqCPM":
					{
						xConversionSymbol = "CPM";
						break;
					}
					default:
					{
						xConversionSymbol = "Hz";
						break;
					}
				}
				xConversionFunction = IncheckModel.instance().getFrequencyUnitsConversionFunction(xConversionSymbol);
			}
			// the y-axis title is determined by what units are selected in the menubar.  Then we get the correct unit conversion function that will convert the chartdata's default units from the ChannelWidget
			if (IncheckModel.instance().graphMenuSelectionAnalysis == "accel")
			{
				switch (IncheckModel.instance().AccEUnit)
				{
					case "AccInSec2":
					{
						yConversionSymbol = "in/s²";
						break;
					}
					case "AccMtrPerSec2":
					{
						yConversionSymbol = "m/s²";
						break;
					}
					case "AccMmSec2":
					{
						yConversionSymbol = "mm/s²";
						break;
					}
					case "AccDb":
					{
						yConversionSymbol = "dB";
						break;
					}
					default:
					{
						yConversionSymbol = "g";
						break;
					}
				}
				yConversionFunction = IncheckModel.instance().getAccelerationUnitsConversionFunction(yConversionSymbol);
			}
			else if (IncheckModel.instance().graphMenuSelectionAnalysis == "velo")
			{
				switch (IncheckModel.instance().VelEUnit)
				{
					case "VelMtrSec":
					{
						yConversionSymbol = "m/s";
						break;
					}
					case "VelMmSec":
					{
						yConversionSymbol = "mm/s";
						break;
					}
					case "VelDb":
					{
						yConversionSymbol = "dB";
						break;
					}
					default:
					{
						yConversionSymbol = "in/s";
						break;
					}
				}
				yConversionFunction = IncheckModel.instance().getVelocityUnitsConversionFunction(yConversionSymbol);
			}
		}


		public function regenLineSeries():void
		{
//            Logger.log(this, "Regenerate line series");
			var allWidg:Array = getWidgets(IncheckModel.instance().left.analysisWidgets);

			reorganizeWidgets(allWidg);

			numCharts = allWidg.length;
			series = new Array();
			var firstOne:Boolean = true;
			for each (var oneW:ChannelWidget in allWidg)
			{
				if ((!oneW.showGraphOption.selected) || oneW.graphData == null || oneW.graphData.chartData == null)
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
					if (xConversionSymbol == null || yConversionSymbol == null)
					{
						setupConversion();
					}	
					(this.horizontalAxis as LinearAxis).title = xConversionSymbol;
					(this.verticalAxis as LinearAxis).title = yConversionSymbol;
					if (IncheckModel.instance().functionMenuSelectionAnalysis == "spec")
						(this.verticalAxis as LinearAxis).title += " " + IncheckModel.instance().MesTypeAnalysis;
				}
				//Alert.show(ObjectUtil.toString(oneW.processedData));

				if (oneW.graphData.measurementUnit == "ms" || oneW.graphData.measurementUnit == "s")
				{
					var currentMax:Number = ymax; //(this.verticalAxis as LinearAxis).maximum;
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
				var i:int;
				for (i = 0; i < n; i++)
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
				series[series.length] = ls;
			}

			for each (var eachRend:AxisRenderer in this.verticalAxisRenderers)
			{
				eachRend.axis = this.verticalAxis;
				eachRend.setStyle("verticalAxisTitleAlignment", "vertical");
			}
/*			
			var machinesContainer:Canvas = IncheckModel.instance().right.machines;
			if (machinesContainer != null)
			{	
				if (machinesContainer.getChildren().length > 0 && allWidg.length > 0)
				{	
					var machines:Array = (machinesContainer.getChildAt(0) as Machine).displayContainer.getChildren();
					var machinesTotal:int = machines.length;
					var machine:ChannelDisplay1;
					for (i = 0; i < machinesTotal; i++)
					{
						if (allWidg[i] != null)
						{	
							machine = machines[i] as ChannelDisplay1;
							machine.colorPick.selectedColor = (allWidg[i] as ChannelWidget).myColorSet;
						}	
					}
				}	
			}	
*/
			this.invalidateData();
			this.invalidateSeries();
			this.validateNow();
		}


		public function setDashboardColors():void
		{
/*			var i:int;
			var allWidg:Array = IncheckModel.instance().left.selectedChannelsBox.getChildren();
			var machinesContainer:Canvas = IncheckModel.instance().right.machines;
			if (machinesContainer != null)
			{	
				if (machinesContainer.getChildren().length > 0 && allWidg.length > 0)
				{	
					var machines:Array = (machinesContainer.getChildAt(0) as Machine).displayContainer.getChildren();
					var machinesTotal:int = machines.length;
					var machine:ChannelDisplay1;
					for (i = 0; i < machinesTotal; i++)
					{
						if (allWidg[i] != null)
						{	
							machine = machines[i] as ChannelDisplay1;
							(allWidg[i] as ChannelWidget).myColorSet = machine.colorPick.selectedColor;
						}	
					}
				}	
			}	
*/		}


		private function labelFormatter(val:Object, pval:Object, ax:AxisBase):String
		{
			if (val is Number)
			{
				return RangeSelectorAnalysis.toScientific(val as Number);
			}
			return val.toString();
		}


		private function reorganizeWidgets(widgets:Array):void
		{
			var found:Boolean = false;
			var i:uint = 0;
			while (!found && i < widgets.length)
			{
				var widg:ChannelWidget = widgets[i];
				if (widg.selected)
				{
					found = true;
					widgets.splice(i, 1);
					widgets.push(widg);
				}
				i++;
			}
		}


		public function dataTipsFunc(event:HitData):String
		{
			var tip:String = "";
			var item:Object = event.chartItem.item;

			tip = RangeSelectorAnalysis.toScientific(item.y) + " " + yConversionSymbol;
			if (IncheckModel.instance().functionMenuSelectionAnalysis == "spec")
			{
				tip += " " + IncheckModel.instance().MesTypeAnalysis;
			}
			tip += "\n" + RangeSelectorAnalysis.toScientific(item.x) + " " + xConversionSymbol;

			return tip;
		}


		private function setMaxAxisValue():void
		{
			if (IncheckModel.instance().right.autoscaleAnalysis)
			{
				if (IncheckModel.instance().right.tabs.selectedIndex == 0)
				{
					if ((IncheckModel.instance().right as RightNavigator).autoscaleAnalysis.selected)
					{
						(this.verticalAxis as LinearAxis).maximum = ymax;
					}
					else
					{
						if (IncheckModel.instance().graphMenuSelectionAnalysis == "accel")
						{
							(this.verticalAxis as LinearAxis).maximum = IncheckModel.instance().userPreferencesModel.defaultAccelerationScale;
						}
						else
						{
							(this.verticalAxis as LinearAxis).maximum = IncheckModel.instance().userPreferencesModel.defaultVelocityScale;
						}
					}
				}
				else
				{
					if ((IncheckModel.instance().right as RightNavigator).autoscaleAnalysis.selected)
					{
						(this.verticalAxis as LinearAxis).maximum = ymax;
					}
					else
					{
						if (IncheckModel.instance().graphMenuSelectionAnalysis == "accel")
						{
							(this.verticalAxis as LinearAxis).maximum = IncheckModel.instance().userPreferencesModel.defaultAccelerationScale;
						}
						else
						{
							(this.verticalAxis as LinearAxis).maximum = IncheckModel.instance().userPreferencesModel.defaultVelocityScale;
						}
					}
				}
			}
		}


		private function setMinAxisValue():void
		{
			if (IncheckModel.instance().functionMenuSelectionAnalysis == "wave")
			{
				if (IncheckModel.instance().right.tabs.selectedIndex == 0)
				{
					if ((IncheckModel.instance().right as RightNavigator).autoscaleAnalysis.selected)
					{
						(this.verticalAxis as LinearAxis).minimum = ymin;
					}
					else
					{
						if (IncheckModel.instance().graphMenuSelectionAnalysis == "accel")
						{
							(this.verticalAxis as LinearAxis).minimum = -IncheckModel.instance().userPreferencesModel.defaultAccelerationScale;
						}
						else
						{
							(this.verticalAxis as LinearAxis).minimum = -IncheckModel.instance().userPreferencesModel.defaultVelocityScale;
						}
					}
				}
				else
				{
					if ((IncheckModel.instance().right as RightNavigator).autoscaleAnalysis.selected)
					{
						(this.verticalAxis as LinearAxis).minimum = ymin;
					}
					else
					{
						if (IncheckModel.instance().graphMenuSelectionAnalysis == "accel")
						{
							(this.verticalAxis as LinearAxis).minimum = -IncheckModel.instance().userPreferencesModel.defaultAccelerationScale;
						}
						else
						{
							(this.verticalAxis as LinearAxis).minimum = -IncheckModel.instance().userPreferencesModel.defaultVelocityScale;
						}
					}
				}
			}
			else
			{
				(this.verticalAxis as LinearAxis).minimum = ymin;
			}
		}


		public function onAutoScaleChanged():void
		{
			setMaxAxisValue();
			setMinAxisValue();
		}


		public function clearData():void
		{
			this.series = new Array();
			this.verticalAxis = new LinearAxis();
			(this.verticalAxis as LinearAxis).autoAdjust = true;
			var verAxRend:AxisRenderer = new AxisRenderer();
			verAxRend.axis = this.verticalAxis;
			this.horizontalAxis = new LinearAxis();
			(this.horizontalAxis as LinearAxis).autoAdjust = true;
			for each (var eachRend:AxisRenderer in this.verticalAxisRenderers)
			{
				eachRend.axis = this.verticalAxis;
				eachRend.setStyle("verticalAxisTitleAlignment", "vertical");
			}
			this.invalidateData();
			this.invalidateSeries();
			this.validateNow();
		}


		public function isNodePresent(node:ICNode):Boolean
		{
			var result:Boolean = false;
			var l:int = series.length;
			if (l > 0)
			{
				for (var i:int = 0; i < l; i++)
				{
					if ((series[i] as InCheckLineSeries).node == node)
					{
						result = true;
						break;
					}
				}
			}
			return result;
		}
		
		
		public function invalidate():void
		{
			invalidateDisplayList();			
		}	

	}
}
