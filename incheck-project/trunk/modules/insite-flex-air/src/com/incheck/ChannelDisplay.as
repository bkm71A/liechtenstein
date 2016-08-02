package com.incheck
{
	import com.incheck.common.ICNode;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;

	public class ChannelDisplay extends VBox
	{
		private var node:ICNode;
		private var parMachine:Machine;
		private var channelName:Label = new Label();
		private var close:Image;
		public var rms:Label = new Label();
		public var overAllType:Label = new Label();
		private var chart:IncheckChart = null;
		
		[Embed("/assets/add.png")]
		private const _btnAdd:Class;

		[Embed("/assets/stop.png")]
		private const _btnStop:Class;

		
		public function ChannelDisplay(_node:ICNode, _machineCont:Machine)
		{
			this.node = _node;
			this.parMachine = _machineCont;
			initUI();
			init(node);		
		}
		
		public function channelId():int
		{
			return node.id;
		}
		
		private function initUI():void
		{
			setStyle("backgroundColor","#ffffff");
			setStyle("horizontalScrollPolicy","off");
			setStyle("verticalScrollPolicy","off");
			setStyle("verticalGap", 0);
			channelName.height = 19;
			channelName.setStyle("fontSize", 15); 
			channelName.setStyle("horizontalCenter", "0");
					
/*	
			var addToDV:Image = new Image();
			addToDV.source = _btnAdd;
			addToDV.width = 16;
			addToDV.height = 16;
			addToDV.setStyle("right", 18);
			addToDV.addEventListener(MouseEvent.CLICK, addToChart);

			close = new Image();
			close.source = _btnStop;
			close.width = 16;
			close.height = 16;
			close.setStyle("right", 0);
			close.addEventListener(MouseEvent.CLICK, closeDisplay);
*/
			
			var headerBox:Canvas = new Canvas();
			//headerBox.setStyle("borderStyle", "solid");
			headerBox.percentWidth = 100;
			headerBox.addChild(channelName);
//			headerBox.addChild(addToDV);
//			headerBox.addChild(close);
			
			var hbox2:HBox = new HBox();
			hbox2.percentWidth = 100;
			hbox2.percentHeight = 100;	
			hbox2.setStyle("horizontalScrollPolicy","off");
			hbox2.setStyle("verticalScrollPolicy","off");
			//hbox2.setStyle("borderStyle", "solid");
			hbox2.setStyle("verticalAlign", "bottom");
			hbox2.setStyle("horizontalGap", 0);
			
			var rmsandtypeBox:VBox = new VBox();
			rmsandtypeBox.percentHeight = 100;
			rmsandtypeBox.setStyle("verticalAlign", "middle");
			rmsandtypeBox.setStyle("paddingBottom", 20);
			
			rms.setStyle("fontFamily","Verdana");
			rms.setStyle("fontSize","11");
//			rms.setStyle("fontWeight","bold");
			
			rmsandtypeBox.addChild(rms);
			
			overAllType.setStyle("fontFamily","Verdana");
			overAllType.setStyle("fontSize","11");
//			overAllType.setStyle("fontWeight","bold");
			
			rmsandtypeBox.addChild(overAllType);
			
			hbox2.addChild(rmsandtypeBox);
			
			var types:ArrayCollection = IncheckModel.instance().getAvailableCharts(node);
			
			if (types != null && types.length > 0)
			{
				var type2get:String = null;
				if (node.channelType == 2) // static channel
				{
					type2get = "Recent Trend";
				}
				else if (node.channelType == 1) // dynamic channel
				{
					if (IncheckModel.instance().getUserVibrationType() == "Acceleration")
						type2get = "Overalls Trend - Acceleration, RMS";
					else if (IncheckModel.instance().getUserVibrationType() == "Velocity")
						type2get = "Overalls Trend - Velocity, RMS";
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
						overAllType.text = IncheckModel.instance().getUserAccelerationUnits() + " RMS";
						yConversionFunction = IncheckModel.instance().getAccelerationUnitsConversionFunction();
					}
					else if (type2get.match("Velocity"))
					{
						overAllType.text = IncheckModel.instance().getUserVelocityUnits() + " RMS";
						yConversionFunction = IncheckModel.instance().getVelocityUnitsConversionFunction();
					}
					else if (type2get.match("Displacement"))
					{
						overAllType.text = IncheckModel.instance().getUserDisplacementUnits();
						yConversionFunction = IncheckModel.instance().getDisplacementUnitsConversionFunction();
					}

					chart = new IncheckChart();
					chart.yConversionFunction = yConversionFunction;
					chart.initChart(node.channelid, type2get);
					chart.percentWidth = 100;
					chart.percentHeight = 100;	
					chart.chDisplayObj = this;
					hbox2.addChild(chart);

					var seconds:Label = new Label();
					seconds.text = "s";
					seconds.setStyle("fontFamily", "Verdana");
					seconds.setStyle("fontSize", "11");
//					seconds.setStyle("fontWeight", "bold");
					
					hbox2.addChild(seconds);
				}
			}													
			
			addChild(headerBox);
			addChild(hbox2);
					
			setStyle("borderColor", "silver");
			setStyle("borderThickness", "1");
			setStyle("borderStyle", "solid");
		}
		
		private function init(node:ICNode):void
		{			
			channelName.text = node.name;
			var color:String = com.incheck.Status.getStatusColor(node.state);
			if (chart != null)
			{			
				chart.register();
			}
			rms.text = "0";
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
				parMachine.parent.removeChild(parMachine);
			}
		}
		
		private function addToChart(ev:Event):void
		{
			IncheckModel.instance().addChart(node, null);
		}
	}
}