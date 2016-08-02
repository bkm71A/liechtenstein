package com.incheck.components
{
	import com.incheck.IncheckModel;
	import com.incheck.Machine;
	import com.incheck.common.ICNode;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;

	
	public class ChannelDisplay2 extends VBox
	{
		private var _node:ICNode;
		private var _parMachine:Machine;
		public var rms:String;
		public var overAllType:Label = new Label();

		
		public function ChannelDisplay2()
		{
		}
		
		
		[Bindable]
		public function get machine():Machine
		{
			return _parMachine;
		}

		
		public function set machine(value:Machine):void
		{
			_parMachine = value;
		}

		
		[Bindable]
		public function get node():ICNode
		{
			return _node;
		}

		
		public function set node(value:ICNode):void
		{
			_node = value;
		}

		
		public function channelId():int
		{
			return _node.id;
		}
		
		
		public function init(node:ICNode = null):void
		{			
			if (node != null && node != _node)
			{
				_node = node;
			}	
			var color:String = com.incheck.Status.getStatusColor(_node.state);
		}
				

		private function addToChart(ev:Event):void
		{
			IncheckModel.instance().addChart(_node, null);
		}
	}
}