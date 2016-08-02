package com.incheck.components.model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="com.inchecktech.dpm.beans.FunctionDataVO")]
	public class FunctionDataVO
	{
		public var waveformData:GraphDataVO;
		public var spectrumData:GraphDataVO;
		
		
		public function FunctionDataVO(obj:Object = null):void
		{
			if (obj)
			{	
				fromObject(obj);
			}	
		}
		
		
		public function fromObject(obj:Object):void
		{
			if (obj.hasOwnProperty("waveformData"))
			{
				waveformData = obj.waveformData as GraphDataVO;
			}	
			if (obj.hasOwnProperty("spectrumData"))
			{
				spectrumData = obj.spectrumData as GraphDataVO;
			}	
		}	
	}
}