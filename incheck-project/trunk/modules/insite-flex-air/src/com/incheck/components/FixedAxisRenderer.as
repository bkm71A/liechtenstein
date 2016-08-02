package com.incheck.components
{
	import mx.charts.AxisRenderer;
	
	public class FixedAxisRenderer extends AxisRenderer
	{
		public function FixedAxisRenderer()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			try {
				super.updateDisplayList(unscaledWidth, unscaledHeight);
			} catch (e:Error) {
				trace (e.message);
			}
		}
	}
}