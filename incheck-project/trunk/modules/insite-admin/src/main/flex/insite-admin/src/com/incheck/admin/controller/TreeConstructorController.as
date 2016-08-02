package com.incheck.admin.controller {
	import com.incheck.admin.event.AdminServiceEvent;
	import com.incheck.admin.event.HierarchyEvent;
	import com.incheck.admin.model.TreeNode;
	import com.incheck.admin.service.AdminService;
	import com.incheck.admin.view.constructor.ITreeConstructor;

	import mx.collections.ArrayCollection;

	public class TreeConstructorController extends BaseController {

		private var view : ITreeConstructor;
		private var modules : ArrayCollection;
		private var locations : ArrayCollection;

		public function TreeConstructorController(view : ITreeConstructor, service : AdminService) {
			this.service = service;
			this.view = view;
			this.view.whenChangeParent(onChangeParent);
			service.addEventListener(AdminServiceEvent.MODULES_RECEIVED, onGetModules);
			service.addEventListener(AdminServiceEvent.LOCATIONS_RECEIVED, onGetLocations);
		}

		public function refresh() : void {
			view.refresh();
		}

		private function onGetModules(event : AdminServiceEvent) : void {
			this.modules = event.modules;
			view.updateModules(this.modules);
		}

		private function onGetLocations(event : AdminServiceEvent) : void {
			this.locations = event.locations;
			view.updateLocations(this.locations);
		}


		private function onChangeParent(parentNode : TreeNode, childNode : Object) : void {
			var event : HierarchyEvent = new HierarchyEvent(HierarchyEvent.PARENT_CHANGED);
			event.node = parentNode;
			event.childNode = childNode;
			dispatchEvent(event);
		}
	}
}
