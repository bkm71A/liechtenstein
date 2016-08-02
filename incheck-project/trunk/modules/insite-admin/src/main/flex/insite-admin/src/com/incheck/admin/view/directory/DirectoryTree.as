package com.incheck.admin.view.directory {
	import com.incheck.admin.model.Channel;
	import com.incheck.admin.model.Module;

	import mx.controls.Tree;

	public class DirectoryTree extends Tree {

		[Embed("/../imgs/module.png")]
		public static var deviceClass : Class;
		[Embed("/../imgs/blue_line.png")]
		public static var channelClass : Class;

		public function DirectoryTree() {
			super();
			dataDescriptor = new DirectoryTreeDataDescriptor();
			labelFunction = directoryTreeLabelFunction;
		}

		public static function icIconFunction(obj : Object) : Class {
			if (obj is Module) {
				return deviceClass;
			} else if ((obj is Channel) && (obj as Channel).sensor) {
				return channelClass;
			}
			return null;
		}

		private function directoryTreeLabelFunction(item : Object) : String {
			if (item is Module) {
				return (item as Module).deviceID;
			} else if (item is Channel) {
				return (item as Channel).channelID;
			}
			return "";
		}

	}
}
