package com.incheck
{
	import com.incheck.common.ICNode;
	
	import mx.charts.HitData;
	import mx.charts.chartClasses.CartesianTransform;
	import mx.charts.series.LineSeries;
	import mx.charts.series.items.LineSeriesItem;
	import mx.graphics.IStroke;
	import mx.graphics.LinearGradientStroke;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;


	public class InCheckLineSeries extends LineSeries
	{

		public var node:ICNode = null;


		public function InCheckLineSeries()
		{
			super()
		}


		/**
 *  @private
*/
		override public function findDataPoints(x:Number, y:Number, sensitivity:Number):Array /* of HitData */
		{
			if (interactive == false || !renderData)
				return [];

			var pr:Number = getStyle("radius");
			var minDist2:Number = pr + sensitivity;
			minDist2 *= minDist2;
			var minItem:LineSeriesItem = null;
			var pr2:Number = pr * pr;

			var len:int = 0;

			if (renderData != null && renderData.filteredCache != null)
			{
				len = renderData.filteredCache.length;
			}


			if (len == 0)
				return [];

			if (sortOnXField == true)
			{
				var low:Number = 0;
				var high:Number = len;
				var cur:Number = Math.floor((low + high) / 2);

				var bFirstIsNaN:Boolean = isNaN(renderData.filteredCache[0]);

				while (true)
				{
					var v:LineSeriesItem = renderData.filteredCache[cur];
					if (!isNaN(v.yNumber) && !isNaN(v.xNumber))
					{
						var dist:Number = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
						if (dist <= minDist2)
						{
							minDist2 = dist;
							minItem = v;
						}
					}
					if (v.x < x || (isNaN(v.x) && bFirstIsNaN))
					{
						low = cur;
						cur = Math.floor((low + high) / 2);
						if (cur == low)
							break;
					}
					else
					{
						high = cur;
						cur = Math.floor((low + high) / 2);
						if (cur == high)
							break;
					}
				}
			}
			else
			{
				var i:uint;
				for (i = 0; i < len; i++)
				{
					v = renderData.filteredCache[i];
					if (!isNaN(v.yFilter) && !isNaN(v.xFilter))
					{
						dist = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
						if (dist <= minDist2)
						{
							minDist2 = dist;
							minItem = v;
						}
					}
				}
			}

			if (minItem)
			{
				var hd:HitData = new HitData(createDataID(minItem.index), Math.sqrt(minDist2), minItem.x, minItem.y, minItem);

				var istroke:IStroke = getStyle("lineStroke");
				if (istroke is SolidColorStroke)
					hd.contextColor = SolidColorStroke(istroke).color;
				else if (istroke is LinearGradientStroke)
				{
					var gb:LinearGradientStroke = LinearGradientStroke(istroke);
					if (gb.entries.length > 0)
						hd.contextColor = gb.entries[0].color;
				}
				hd.dataTipFunction = formatDataTip;
				return [hd];
			}

			return [];
		}


		/**
		 *  @private
		 */
		private function formatDataTip(hd:HitData):String
		{
			var dt:String = "";

			var n:String = displayName;
			if (n && n != "")
				dt += "<b>" + n + "</b><BR/>";

			var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
			if (xName != "")
				dt += "<i>" + xName + ":</i> ";
			dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(LineSeriesItem(hd.chartItem).xValue) + "\n";

			var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
			if (yName != "")
				dt += "<i>" + yName + ":</i> ";
			dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(LineSeriesItem(hd.chartItem).yValue) + "\n";

			return dt;
		}


	}
}
