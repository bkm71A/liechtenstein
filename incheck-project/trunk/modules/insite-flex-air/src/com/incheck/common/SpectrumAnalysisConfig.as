package com.incheck.common
{
	[Managed]
	[RemoteClass(alias="com.inchecktech.dpm.config.SpectrumAnalysisConfig")]
	public class SpectrumAnalysisConfig
	{
		
		
		public var analysisBandwidth:Number;
		public var damSamplingRate:Number;  
		public var spectrumLines:Number;
		public var damBlockSize:Number;
		public var dspSamplingRate:Number;
		public var current:Boolean;
		public var channelId:Number;
		
		public function SpectrumAnalysisConfig()
		{
		}

	}
}