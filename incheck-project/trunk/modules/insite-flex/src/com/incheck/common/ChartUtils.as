package com.incheck.common
{
	public class ChartUtils
	{
		public function ChartUtils()
		{
		}
		
		/**Before the data is displayed it is checked if data > 80% of 
		*full scale or <10% of full scale If data > 80%, 
		*the full scale is doubled (becomes 1.60) and data is checked again. 
		*If data < 20%, the full scale is halved (becomes 0.4) and data is checked again. 
		*Only if data is within 20 to 80% of full scale it is plotted 
		*/
		public static function getMaxValue(ymax:Number, defaultMax:Number):Number{
			while(ymax <= defaultMax*0.2 || ymax >= defaultMax*0.8){
				if(ymax <= defaultMax*0.2){
					defaultMax = defaultMax/2;
				}else if (ymax >= defaultMax*0.8){
					defaultMax = defaultMax*2;
				}
			}
			return defaultMax;
		}
		
		public static function getMinValue(ymin:Number, defaultMin:Number):Number{
			while(ymin >= defaultMin*0.2 || ymin <= defaultMin*0.8){
				if(ymin >= defaultMin*0.2){
					defaultMin = defaultMin/2;
				}else if (ymin <= defaultMin*0.8){
					defaultMin = defaultMin*2;
				}
			}
			return defaultMin;
		}
	}
}