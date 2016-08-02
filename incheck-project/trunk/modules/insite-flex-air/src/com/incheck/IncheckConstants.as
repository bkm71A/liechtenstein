
package com.incheck
{
	public class IncheckConstants
	{
		public static var CHART_TYPE_TREND:String    = "Recent Trend";
		public static var CHART_TREND_NAME:String    = "Velocity, in/sec";
		public static var TYPE_TREND:uint = 1;
		
		public static var CHART_TYPE_WAVEFORM:String = "Spectrum - Acceleration (Peak)";
		public static var CHART_WAVEFORM_NAME:String = "Spectrum - Acceleration (Peak)";
		public static var TYPE_WAVEFORM:uint = 2;
		
		public static var CHART_SPECTRUM_NAME:String = "Spectrum Chart";
		public static var CHART_TYPE_SPECTRUM:uint = 3;
		public static var TYPE_SPECTRUM:uint = 3;
				
		public static var CHART_TYPE_SPECTRUM_A:String = "Frequency (A)";
		public static var CHART_SPECTRUM_A_NAME:String = "Frequency (A)";
		
		public static var CHART_TYPE_SPECTRUM_V:String = "Frequency (V)";
		public static var CHART_SPECTRUM_V_NAME:String = "Frequency (V)";
		
		public static var CHART_TYPE_SPECTRUM_D:String = "33";				
		public static var CHART_SPECTRUM_D_NAME:String = "Spectrum Type D Chart";
		
						// Recent Trend
		public static var ID:String = "id";
		public static var STATUS:String = "status";
		public static var TEMP:String = "temp";
		public static var TEMP_TYPE:String = "tempType";
		
		/**
		 * Chart Selection Menu 
		 */
		 
		 /*
		 
		 
		 */
		public static var chartSelectXml:String = 
			"<root>"
				+ "<menuItem label=\"Trend\"     id= \"" + CHART_TYPE_TREND + "\"/>"
				+ "<menuItem label=\"Wave Form\" id= \"" + CHART_TYPE_WAVEFORM + "\"/>"
				+ "<menuItem label=\"Spectrum\"  id= \"" + CHART_TYPE_SPECTRUM + "\">"
					+ "<menuItem label=\"Spectrum A\" id = \"" + CHART_TYPE_SPECTRUM_A+ "\"/>"
					+ "<menuItem label=\"Spectrum V\" id = \"" + CHART_TYPE_SPECTRUM_V + "\"/>"
					+ "<menuItem label=\"Spectrum D\" id = \"" + CHART_TYPE_SPECTRUM_D + "\"/>"
				+ "</menuItem>"
			+ "</root>";
			

	}
	

			
}