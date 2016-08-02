package com.incheck
{
	import com.incheck.common.ICNode;
	import com.incheck.components.*;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	
	
	public class Machine extends Canvas
	{
		private var machine:ICNode;
		
		private var myChildren:ArrayCollection;
		private var myChildrenID:ArrayCollection;
		public var displayContainer:HBox;
		
		
		public function Machine(node:ICNode)
		{
			this.machine = node;
//			this.setStyle("backgroundColor","#91bfbd");
			myChildren = new ArrayCollection();
			myChildrenID = new ArrayCollection();
			displayContainer = new HBox();
			displayContainer.percentWidth = 100;
			displayContainer.percentHeight = 100;
			displayContainer.setStyle("paddingLeft", 5);
			displayContainer.setStyle("paddingRight", 5);
			displayContainer.setStyle("paddingTop", 5);
			displayContainer.setStyle("paddingBottom", 5);
			this.addChild(displayContainer);
			// this.horizontalScrollPolicy = 
			// this.percentWidth=100;
			/*
			width = 100;
			height = 100;

			setStyle("borderColor", "blue");
			setStyle("borderThickness", "2");
			setStyle("borderStyle", "solid");
			*/
/*			
			var mpath:String = node.name;
			var pnode:ICNode = node.parent;
			while (pnode != null)
			{
				mpath = pnode.name + " : " + mpath;
				pnode = pnode.parent;
			}
			this.title = mpath;
*/
			this.autoLayout = true;
		}
		
		public function getMachineID():int
		{
			return machine.id;
		}
		
		public function add(channel:ICNode):void
		{			
			if (!exists(channel))
			{			
				var display:ChannelDisplay1 = new ChannelDisplay1();
				display.node = channel;
				display.machine = this;
				display.init();
				displayContainer.addChild(display);
				validateNow();
/*				if (displayContainer.width > this.parent.width)
				{
					displayContainer.width = this.width;
				}
*/				myChildren.addItem(channel);
				myChildrenID.addItem(channel.channelid);
			}
		}
		
		public function addAll(children:Array):void
		{
			for each (var child:ICNode in children)
			{
				if (child.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
				{
					if (child.name == "WIVib1")
					{
						continue;
					}
					add(child);
				}				
			}
		}
		
		public function remove(channel:ICNode):void
		{
			var index:int = getChannelIndex(channel);
			if (index >= 0)
			{
				displayContainer.removeChildAt(index);
				myChildren.removeItemAt(index);
				myChildrenID.removeItemAt(myChildrenID.getItemIndex(channel.channelid));
			}
		}
		
		public function exists(channel:ICNode):Boolean
		{
			return myChildrenID.contains(channel.channelid);			
		}
		
		public function getChannelCount():uint
		{
			return displayContainer.numChildren;
		}
		
		private function getChannelIndex(channel:ICNode):int
		{
			return myChildren.getItemIndex(channel);
		}
		
		public function getMachine():ICNode
		{
			return machine;
		}		
		
	}
}