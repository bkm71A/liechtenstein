package com.incheck.admin.view.constructor {
	import com.incheck.admin.model.Channel;
	import com.incheck.admin.model.Location;
	import com.incheck.admin.model.Module;
	import com.incheck.admin.model.TreeNode;

	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.Tree;
	import mx.core.mx_internal;
	import mx.events.DragEvent;

	use namespace mx_internal;

	public class TreeConstructorBase extends HBox implements ITreeConstructor {
		[Bindable]
		public var modules : ArrayCollection;
		[Bindable]
		public var filteredModules : ArrayCollection = new ArrayCollection();
		[Bindable]
		public var nodes : ArrayCollection;
		[Bindable]
		public var locations : ArrayCollection;
		[Bindable]
		public var filteredLocations : ArrayCollection = new ArrayCollection();

		private var whenChangeParentFunction : Function;

		public function TreeConstructorBase() {
		}

		protected function labelFunction(item : Object) : String {
			if (item is TreeNode) {
				return (item as TreeNode).name;
			} else if (item is Channel) {
				return (item as Channel).channelID;
			}
			return "";
		}

		public function updateModules(modules : ArrayCollection) : void {
			this.modules = modules;
			refresh();
		}

		public function updateLocations(locations : ArrayCollection) : void {
			this.locations = locations;
			refresh();
		}

		protected function handleDragDrop(event : DragEvent) : void {
			event.preventDefault();
			var tree : Tree = event.target as Tree;
			tree.hideDropFeedback(event);
			var parent : TreeNode = getObjectTarget() as TreeNode;
			if (event.dragSource.hasFormat("treeItems")) {
				var objects : Object = event.dragSource.dataForFormat("treeItems");
			}

			var obj : Object = objects[0];

			if ((!parent) && (obj is Location)
					|| parent && (parent.type == TreeNode.NODE_LOCATION) && (obj is Module)
					|| parent && (parent.type == TreeNode.NODE_MACHINE) && (obj is Channel)) {
				whenChangeParentFunction(parent, obj);
			} else if (obj is TreeNode) {
				var node : TreeNode = obj as TreeNode;
				if ((!parent) && (node.type == TreeNode.NODE_LOCATION)
						|| parent && (parent.type == TreeNode.NODE_LOCATION) && (node.type == TreeNode.NODE_MACHINE)
						|| parent && (parent.type == TreeNode.NODE_MACHINE) && (node.type == TreeNode.NODE_CHANNEL)) {
					whenChangeParentFunction(parent, node);
				}
			}
		}

		public function refresh() {
			filteredLocations.removeAll();
			for each (var location : Location in locations) {
				if (location.id) {
					filteredLocations.addItem(location);
				}
			}
			filteredModules = new ArrayCollection();
			for each (var module : Module in modules) {
				if (module.id) {
					filteredModules.addItem(module);
				}
			}
		}

		protected function getObjectTarget() : Object {
			return null;
		}

		public function whenChangeParent(func : Function) : void {
			whenChangeParentFunction = func;
		}
	}
}
