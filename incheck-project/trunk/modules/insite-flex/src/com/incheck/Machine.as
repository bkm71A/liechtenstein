package com.incheck
{
	import com.incheck.common.ICNode;
	import com.incheck.components.skins.DefaultPanelSkin;
	
	import mx.collections.ArrayCollection;
	import spark.components.Panel;
	import mx.containers.Tile;
	
	public class Machine extends Panel
	{
		private var machine:ICNode;
		
		private var myChildren:ArrayCollection;
		private var myChildrenID:ArrayCollection;
		private var ChildrenLineDisp:Tile;
		
		
		public function Machine(node:ICNode)
		{
			this.machine = node;
			this.setStyle("skinClass", com.incheck.components.skins.DefaultPanelSkin);
			this.setStyle("backgroundColor","#91bfbd");
			myChildren = new ArrayCollection();
			myChildrenID = new ArrayCollection();
			ChildrenLineDisp = new Tile();
			ChildrenLineDisp.setStyle("paddingLeft", 5);
			ChildrenLineDisp.setStyle("paddingRight", 5);
			ChildrenLineDisp.setStyle("paddingTop", 5);
			ChildrenLineDisp.setStyle("paddingBottom", 5);
			this.addElement(ChildrenLineDisp);
			var mpath:String = node.name;
			var pnode:ICNode = node.parent;
			while (pnode != null)
			{
				mpath = pnode.name + " : " + mpath;
				pnode = pnode.parent;
			}
			this.title = mpath;
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
				var display:ChannelDisplay = new ChannelDisplay(channel, this);
				display.width = 295;
				display.height = 210;
				ChildrenLineDisp.addChild(display);
				validateNow();
				if (ChildrenLineDisp.width > this.parent.width)
				{
					ChildrenLineDisp.width = this.width;
				}
				myChildren.addItem(channel);
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
				ChildrenLineDisp.removeChildAt(index);
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
			return ChildrenLineDisp.numChildren;
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