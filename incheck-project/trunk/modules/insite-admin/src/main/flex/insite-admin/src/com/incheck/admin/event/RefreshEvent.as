package com.incheck.admin.event {
	import flash.events.Event;

	import mx.collections.ArrayCollection;

	public class RefreshEvent extends Event {
		public static const DATA_UPDATED : String = "dataUpdated";

		public var modules : ArrayCollection;
		public var locations : ArrayCollection;

		public function RefreshEvent(type : String) {
			super(type)
		}
	}
}
