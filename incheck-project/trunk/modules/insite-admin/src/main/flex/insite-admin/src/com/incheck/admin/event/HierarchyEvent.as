package com.incheck.admin.event {
	import com.incheck.admin.model.TreeNode;

	import flash.events.Event;

	public class HierarchyEvent extends Event {

		public static const NODE_CREATED : String = "nodeCreated";
		public static const PARENT_CHANGED : String = "parentChange";

		public var node : TreeNode;
		public var childNode : Object;

		public function HierarchyEvent(type : String) {
			super(type);
		}
	}
}
