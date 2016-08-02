package com.incheck
{
	public class Constants
	{
		
		//
		public static const colorsArray:Array = [
			0x000000, 
			0xff0000, 
			0x00ffff, 
			0x0000ff, 
			0xff00ff, 
			0x00ff00,
			0xc0c0c0,
			0x808080,
			0x808000,
			0x800080,
			0x800000,
			0x008080,
			0x008000,
			0x000080
		];
		
		public static const SECONDS:String = "seconds";
		public static const HOURS:String = "hours";
		public static const DAYS:String = "days";
		public static const WEEKS:String = "weeks";
		
		// channel types
		public static const DYNAMIC_CHANNEL:int = 1;
		public static const STATIC_CHANNEL:int = 2;
		
		//overalls
		public static const OVERALL_PEAK_2_PEAK:String = "Peak To Peak";
		public static const OVERALL_PEAK:String = "Peak";
		public static const OVERALL_RMS:String = "RMS";
		
		// measurement labels
		public static const MEASUREMENT_LABEL_G:String = "g";
		public static const MEASUREMENT_LABEL_IN_S_2:String = "in/s²";
		public static const MEASUREMENT_LABEL_M_S_2:String = "m/s²";
		public static const MEASUREMENT_LABEL_MM_S_2:String = "mm/s²";
		
		public static const ACCELERATION_MEASUREMENT:Array = [MEASUREMENT_LABEL_G, MEASUREMENT_LABEL_IN_S_2, MEASUREMENT_LABEL_M_S_2, MEASUREMENT_LABEL_MM_S_2];
		
		public static const MEASUREMENT_LABEL_DB:String = "dB";
		
		public static const MEASUREMENT_LABEL_IN_S:String = "in/s";
		public static const MEASUREMENT_LABEL_M_S:String = "m/s";
		public static const MEASUREMENT_LABEL_MM_S:String = "mm/s";
		
		public static const VELOCITY_MEASUREMENT:Array = [MEASUREMENT_LABEL_IN_S, MEASUREMENT_LABEL_M_S, MEASUREMENT_LABEL_MM_S];
		
		public static const MEASUREMENT_LABEL_C:String = "°C";
		public static const MEASUREMENT_LABEL_F:String = "°F";
		
		public static const MEASUREMENT_LABEL_PSI:String = "psi";
		public static const MEASUREMENT_LABEL_PA:String = "Pa";
		public static const MEASUREMENT_LABEL_BAR:String = "bar";
		public static const MEASUREMENT_LABEL_KGF_CM_2:String = "kgf/cm²";
		
		public static const MEASUREMENT : Array = ["", MEASUREMENT_LABEL_G, "", "", MEASUREMENT_LABEL_C, MEASUREMENT_LABEL_PA, MEASUREMENT_LABEL_MM_S_2, MEASUREMENT_LABEL_IN_S,
			MEASUREMENT_LABEL_MM_S, MEASUREMENT_LABEL_IN_S_2]; 
		
		//
		public static const KEY_ACCEL_RMS:String = "Accel_Rms";
		public static const KEY_ACCEL_PEAK:String = "Accel Peak";
		public static const KEY_ACCEL_PEAK_TO_PEAK:String = "Accel Peak To Peak";
		public static const KEY_VEL_RMS:String = "Vel_Rms";
		public static const KEY_VEL_PEAK:String = "Vel Peak";
		public static const KEY_VEL_PEAK_TO_PEAK:String = "Vel Peak To Peak";
		
		public static const VELOCITY:String = "Velocity";
		public static const ACCELERATION:String = "Acceleration";
		public static const PEAK:String = "Peak";
		public static const RMS:String = "RMS";

		public static const DEFAULT_FREQ_UNITS:String = "FreqHz";
		public static const DEFAULT_TIME_UNITS:String = "TimeSec";
		public static const DEFAULT_ACCELERATION_UNITS:String = "AccG";
		public static const DEFAULT_VELOCITY_UNITS:String = "VelInSec";
		public static const DEFAULT_DISPLACEMENT_UNITS:String = "DisplMil";
		
		public static var ADD_TO_LIST:String = "Add to Dashboard";
		public static var RELOAD_CFG:String = "Reload CHCFG";
		public static var CHART:String = "Chart";
		public static var CHANNELS_LOADING:String = "Waiting while channels loading ({0}/{1})...";

		public static var SERVICE_ID:String = "my-rtmp";
	}
}