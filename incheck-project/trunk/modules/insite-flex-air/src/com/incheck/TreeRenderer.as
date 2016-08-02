package com.incheck
{
	import com.incheck.common.ICNode;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	
	public class TreeRenderer extends TreeItemRenderer 
	{
		private var _myData:Object;
		
		
		public function TreeRenderer()
		{
			
		}	

		
		override public function set data(value:Object):void{
			super.data = value;
			
			var node:ICNode = value as ICNode;
			if(node != null){	
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