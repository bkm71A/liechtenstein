package com.incheck.components
{
	import com.incheck.common.ICNode;
	import com.incheck.components.model.GraphDataVO;
	import com.incheck.components.model.ProcessDataVO;

	
	public interface IChannelWidget
	{
		function get processData():ProcessDataVO

		function get graphData():GraphDataVO

		function set graphData(value:GraphDataVO):void

		function get showGraph():Boolean

		function get node():ICNode;

		function get myColorSet():uint;

		function set myColorSet(value:uint):void;

		function get selected():Boolean;
	}
}