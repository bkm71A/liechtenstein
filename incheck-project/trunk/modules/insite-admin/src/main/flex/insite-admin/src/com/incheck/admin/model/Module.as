package com.incheck.admin.model {
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Module {
		public var id : int;
		public var serialNumber : String;
		public var deviceID : String = "New";
		public var maxChannels : uint;
		public var children : ArrayCollection = new ArrayCollection();
	}
}