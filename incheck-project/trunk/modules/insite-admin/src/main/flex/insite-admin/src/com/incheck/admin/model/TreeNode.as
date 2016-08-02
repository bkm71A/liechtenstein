package com.incheck.admin.model {
	import mx.collections.ArrayCollection;

	[Bindable]
	public class TreeNode extends TreeItem {

		public static const NODE_CHANNEL : String = "Channel";
		public static const NODE_MACHINE : String = "Machine";
		public static const NODE_LOCATION : String = "Location";

		public var children : ArrayCollection = new ArrayCollection();
		public var name : String = 'New';
		public var id : int;
		public var state : uint = 0;
		//public var isBranch : Boolean = true;
		// public var parent : TreeNode;
		public var type : String;
		public var channel : Channel;
		public var channelId : int;
		public var module : Module;
		public var moduleId : int;
		public var location : Location;
		public var locationId : int;
		public var parentId : int;
	}
}
