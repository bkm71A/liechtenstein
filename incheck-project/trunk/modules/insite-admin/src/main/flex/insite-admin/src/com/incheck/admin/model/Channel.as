package com.incheck.admin.model {
	[Bindable]
	public class Channel extends TreeItem {
		public var id : int;
		public var channelType : String;
		public var connectorNum : uint;
		public var channelID : String = "New";
		public var offset : Number;
		public var sensorId : int;
		public var sensor : Sensor;
	}
}