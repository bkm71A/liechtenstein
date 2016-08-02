package com.incheck.components.model
{
	public class MachineVO
	{
		[Bindable]
		public var channel:String = "Channel";

		[Bindable]
		public var title:String = "Title";
		
		[Bindable]
		public var location:String = "Location";
		
		
		public function MachineVO(obj:Object = null):void
		{
			if (obj)
			{
				fromObject(obj);
			}	
		}
		
		
		public function fromObject(obj:Object):void
		{
			if (obj.hasOwnProperty("channel"))
			{
				channel = obj.channel;
			}	
			if (obj.hasOwnProperty("title"))
			{
				title = obj.title;
			}	
			if (obj.hasOwnProperty("location"))
			{
				location = obj.location;
			}	
		}	
	}
}