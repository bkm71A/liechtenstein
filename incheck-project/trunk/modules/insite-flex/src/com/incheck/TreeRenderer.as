package com.incheck
{
	import com.incheck.common.ICNode;
	
	import flash.geom.Point;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.core.IToolTip;
	import mx.events.ToolTipEvent;


	public class TreeRenderer extends TreeItemRenderer
	{
		private var _myData:Object;


		public function TreeRenderer()
		{
			addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, toolTipShown);
		}
		
		/**
		 * Positions the tooltip to show up below the node.
		 * It will move the tooltip above if it would be outside the tree.
		 */
		private function toolTipShown(event:ToolTipEvent):void {
			var tt:IToolTip = event.toolTip;
			// get the global size of this item renderer instances
			var pt:Point = localToGlobal(new Point());
			// position below this item renderer
			var ty:Number = pt.y - this.height;			
			// position the tooltip
			tt.move(tt.x+20, ty);
		}


		override public function set data(value:Object):void
		{
			super.data = value;

			var node:ICNode = value as ICNode;
			if (node != null)
			{
				var color:String = com.incheck.Status.getStatusColor(node.state);
				setStyle("color", color);
			}
		/*
		var xml:XML = XML(value);
		var status:uint = uint(xml.attribute(com.incheck.IncheckConstants.STATUS));
		var temp:int = int(xml.attribute(com.incheck.IncheckConstants.TEMP));
		var color:String = com.incheck.Status.getStatusColor(status);

		setStyle("color", color);
		IncheckModel.instance().channelClicked(tree.selectedItem as ICNode,LeftNavigator.CHART)
		*/
		}
	}
}
