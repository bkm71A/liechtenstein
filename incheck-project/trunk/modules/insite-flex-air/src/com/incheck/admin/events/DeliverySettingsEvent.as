package com.incheck.admin.events
{
	import com.incheck.common.Delivery;
	
	import flash.events.Event;
	
	public class DeliverySettingsEvent extends Event
	{
		
		public static const DELETE_DELIVERY : String = "deleteDelivery";
		public static const EDIT_DELIVERY : String = "editDelivery";
		
		private var _delivery : Delivery;
		
		public function DeliverySettingsEvent(type:String, del : Delivery)
		{
			super(type);
			_delivery = del;
		}
		
		public function get delivery () : Delivery {
			return _delivery;
		}
	}
}