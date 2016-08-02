
package com.incheck
{
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	
	/**
	 * A central place for data sending/receiving 
	 */
	public class IncheckDataProvider
	{
		private static var _instance:IncheckDataProvider;
		
		public static function instance():IncheckDataProvider{
			if(_instance == null){
				_instance = new IncheckDataProvider();
			}
			return _instance;
		}
		
		public final function IncheckDataProvider(){
		}
		/**
		 * 
		 * 
		 * @return <code>String</code> as an xml for tree structure
		 */
		public function getTreeStructure():String{
			return  "<stations label=\"City of Chicago\" status=\"1\" >" + 		
	   			   		"<station label=\"Northern Branch\" status=\"4\" type=\"S\">" +
    	  					"<pump label=\"Pump 1\" status=\"1\" type=\"P\">" +
	         					"<point label=\"Channel 1(Vibration)\" status=\"1\" id=\"1\" type=\"M\""
	         						+ "temp=\"85\" tempType=\"F\"/>" +
         						"<point label=\"Channel 2(Vibration)\" status=\"2\" id=\"2\" type=\"M\""
         							+ "temp=\"150\" tempType=\"F\"/>" +
         						"<point label=\"Channel 3(Vibration)\" status=\"3\" id=\"3\" type=\"M\""
         							+ "temp=\"90\"/>" +
         						"<point label=\"Channel 4(Temperature)\" status=\"3\" id=\"4\" type=\"M\""
         							+ "temp=\"90\"/>" +
      						"</pump>" +
  						"</station>" +  			
	   					"<station label=\"Station 2\" status=\"2\" id=\"4\" type=\"S\""
	   						+ "temp=\"125\" tempType=\"F\"/>" +
   						"<station label=\"Station 3\" status=\"3\" id=\"4\" type=\"S\""
   							+ "temp=\"76\" tempType=\"F\"/>" +
					"</stations>";
		}
		
		public function getChartData(id:Object, type:String):com.incheck.ChartData {
			var ac:ArrayCollection = new ArrayCollection();
			var ls :LineSeries = new LineSeries();
			
			ls.displayName = type;
				
			return new com.incheck.ChartData(ac, ls);
		}
		
		public static function getChartName(chartType:String):String{
			switch(chartType){
				case com.incheck.IncheckConstants.CHART_TYPE_SPECTRUM_A:
					return com.incheck.IncheckConstants.CHART_SPECTRUM_A_NAME;
				case com.incheck.IncheckConstants.CHART_TYPE_SPECTRUM_V:
					return com.incheck.IncheckConstants.CHART_SPECTRUM_V_NAME;
				case com.incheck.IncheckConstants.CHART_TYPE_SPECTRUM_D:
					return com.incheck.IncheckConstants.CHART_SPECTRUM_D_NAME;
				case com.incheck.IncheckConstants.CHART_TYPE_TREND:
					return com.incheck.IncheckConstants.CHART_TREND_NAME;
				case com.incheck.IncheckConstants.CHART_TYPE_WAVEFORM:
					return com.incheck.IncheckConstants.CHART_WAVEFORM_NAME;
				default:
					return "";
			}	
		}
	}		
}