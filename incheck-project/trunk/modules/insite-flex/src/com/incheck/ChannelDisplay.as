package com.incheck
{
	import com.incheck.common.ICNode;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	import mx.controls.Spacer;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.VGroup;


	public class ChannelDisplay extends Group
	{
		private var node:ICNode;

		private var parMachine:Machine;

		private var close:Image;

		public var overAllType:Label;

		private var chart:IncheckGraph = null;

		public var valueLabel:Label;

		public var timeLabel:Label;


		public function ChannelDisplay(_node:ICNode, _machineCont:Machine)
		{
			this.node = _node;
			this.parMachine = _machineCont;
			initUI();
			init(node);
			this.setStyle("backgroundColor", "#ffffff");
		}


		public function channelId():int
		{
			return node.id;
		}


		private function initUI():void
		{
			setStyle("verticalGap", 0);

			var addToDV:Image = new Image();
			addToDV.source = 'resources/add.png';
			addToDV.width = 16;
			addToDV.height = 18;
			addToDV.setStyle("right", 18);
			addToDV.addEventListener(MouseEvent.CLICK, addToChart);

			close = new Image();
			close.source = 'resources/stop.png';
			close.width = 16;
			close.height = 18;
			close.setStyle("right", 0);
			close.addEventListener(MouseEvent.CLICK, closeDisplay);

			var headerBox:HGroup = new HGroup();
			headerBox.percentWidth = 100;
			headerBox.height = 20;
			headerBox.addElement(addToDV);
			headerBox.addElement(close);
			headerBox.paddingRight = 5;
			headerBox.paddingTop = 5;
			headerBox.horizontalAlign = "right";

			var hbox2:HGroup = new HGroup();
			hbox2.percentWidth = 100;
			hbox2.percentHeight = 100;
			hbox2.verticalAlign = "bottom";
			hbox2.gap = 0;

			var timeValueGroup:HGroup = new HGroup();
			timeValueGroup.height = 20;
			timeValueGroup.move(0, 190);
			timeValueGroup.paddingLeft = 10;
			timeValueGroup.paddingRight = 10;
			timeValueGroup.percentWidth = 100;
			timeValueGroup.gap = 0;
			valueLabel = new Label();
			valueLabel.setStyle("fontWeight", "bold");
			valueLabel.text = "0";
			timeValueGroup.addElement(valueLabel);
			overAllType = new Label();
			overAllType.setStyle("fontWeight", "bold");
			timeValueGroup.addElement(overAllType);
			var spacer:Spacer = new Spacer();
			spacer.percentWidth = 100;
			timeValueGroup.addElement(spacer);
			timeLabel = new Label();
			timeLabel.setStyle("fontWeight", "bold");
			timeValueGroup.addElement(timeLabel);

			var types:ArrayCollection = IncheckModel.instance().getAvailableCharts(node);

			chart = new IncheckGraph();
			chart.percentWidth = 100;
			chart.percentHeight = 100;
			chart.chDisplayObj = this;

			if (types != null && types.length > 0)
			{
				var type2get:String = null;
				if (node.channelType == 2) // static channel
				{
					type2get = "Recent Trend";
				}
				else if (node.channelType == 1) // dynamic channel
				{
					type2get = "Overalls Trend - " + IncheckModel.instance().getUserVibrationType() + ", " + IncheckModel.instance().getUserOverallType(); 
					/*if (IncheckModel.instance().getUserVibrationType() == "Acceleration")
						type2get = "Overalls Trend - Acceleration, RMS";
					else if (IncheckModel.instance().getUserVibrationType() == "Velocity")
						type2get = "Overalls Trend - Velocity, RMS";*/
				}
				if (type2get != null)
				{
					var yConversionFunction:Function;
					if (type2get == "Recent Trend")
					{
						overAllType.text = IncheckModel.instance().getUserTemperatureUnits();
						yConversionFunction = IncheckModel.instance().getTemperatureUnitsConversionFunction();
					}
					else if (type2get.match("Acceleration"))
					{
						overAllType.text = IncheckModel.instance().getUserAccelerationUnits() + " " + IncheckModel.instance().getUserOverallType();
						yConversionFunction = IncheckModel.instance().getAccelerationUnitsConversionFunction();
					}
					else if (type2get.match("Velocity"))
					{
						overAllType.text = IncheckModel.instance().getUserVelocityUnits() + " " + IncheckModel.instance().getUserOverallType();
						yConversionFunction = IncheckModel.instance().getVelocityUnitsConversionFunction();
					}
					else if (type2get.match("Displacement"))
					{
						overAllType.text = IncheckModel.instance().getUserDisplacementUnits();
						yConversionFunction = IncheckModel.instance().getDisplacementUnitsConversionFunction();
					}
					chart.initChart(node.channelid, type2get, yConversionFunction);
				}
			}

			chart.register();
			addElement(chart);

			addElement(headerBox);
			addElement(hbox2);
			addElement(timeValueGroup);
		}


		private function init(node:ICNode):void
		{
			chart.chartName = node.name;
			var color:String = com.incheck.Status.getStatusColor(node.state);
		}


		private function closeDisplay(event:MouseEvent):void
		{
			parMachine.remove(node);
			if (chart)
			{
				chart.shouldRun = false;
			}
			if (parMachine.getChannelCount() == 0)
			{
				(parMachine.parent as VGroup).removeElement(parMachine);
			}
		}


		private function addToChart(ev:Event):void
		{
			IncheckModel.instance().addChart(node, null);
		}
	}
}
