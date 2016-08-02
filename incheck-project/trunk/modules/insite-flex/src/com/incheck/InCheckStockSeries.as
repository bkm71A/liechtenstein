package com.incheck
{
	import com.incheck.charts.RangeSelectorHistory;
	import com.incheck.common.ICNode;

	import mx.charts.series.HLOCSeries;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;


	public class InCheckStockSeries extends HLOCSeries
	{

		public var node:ICNode = null;

		private var _overallType:String;


		public function InCheckStockSeries()
		{
			super();

			// setting field names
			openField = "avgValue";
			closeField = "avgValue";
			lowField = "minValue";
			highField = "maxValue"
			xField = "x";
			this.setStyle("openTickLength", 5);
			this.setStyle("closeTickLength", 5);
		}


		public function updateColorSet(color:uint):void
		{
			var stroke:SolidColorStroke = new SolidColorStroke();
			stroke.color = color;
			stroke.joints = "bevel";
			stroke.caps = "square";
			setStyle("stroke", stroke);
			setStyle("openTickStroke", stroke);
			setStyle("closeTickStroke", stroke);

			stroke.weight = 1;
		}


		public function set overallType(value:String):void
		{
			_overallType = value;
		}


		public function get overallType():String
		{
			return _overallType;
		}


		/**
		 *  @private
		 */
		override public function findDataPoints(x:Number, y:Number, sensitivity:Number):Array /* of HitData */
		{
			if (RangeSelectorHistory.areWeZooming)
				return [];
			var res:Array = [];
			try
			{
				res = super.findDataPoints(x, y, sensitivity);
			}
			catch (e:Error)
			{
				trace("error while zooming");
			}
			return res;
		}

	}
}