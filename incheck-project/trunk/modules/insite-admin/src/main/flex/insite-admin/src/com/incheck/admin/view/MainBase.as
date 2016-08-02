package com.incheck.admin.view {
	import com.incheck.admin.controller.ChannelsController;
	import com.incheck.admin.controller.DirectoryController;
	import com.incheck.admin.controller.HierarchyController;
	import com.incheck.admin.controller.LocationController;
	import com.incheck.admin.controller.LocationListController;
	import com.incheck.admin.controller.ModulesController;
	import com.incheck.admin.controller.SensorsController;
	import com.incheck.admin.controller.TreeConstructorController;
	import com.incheck.admin.controller.TreeController;
	import com.incheck.admin.event.ChannelsEvent;
	import com.incheck.admin.event.DirectoryEvent;
	import com.incheck.admin.event.HierarchyEvent;
	import com.incheck.admin.event.LocationListEvent;
	import com.incheck.admin.event.LocationsEvent;
	import com.incheck.admin.event.ModulesEvent;
	import com.incheck.admin.event.RefreshEvent;
	import com.incheck.admin.event.SensorsEvent;
	import com.incheck.admin.event.TreeEvent;
	import com.incheck.admin.service.AdminService;

	import mx.collections.ArrayCollection;
	import mx.core.Application;

	public class MainBase extends Application {
		[Bindable]
		protected var modules : ArrayCollection = new ArrayCollection();
		[Bindable]
		protected var nodes : ArrayCollection = new ArrayCollection();
		[Bindable]
		protected var locations : ArrayCollection = new ArrayCollection();
		[Bindable]
		protected var availableChannels : ArrayCollection = new ArrayCollection();

		protected static const DIRECTORY_VIEW : String = "DirectoryView";
		protected static const HIERARCHY_TREE_VIEW : String = "HierarchyTreeView";
		protected static const LOCATIONS_LIST_VIEW : String = "LocationsListView";
		protected static const VIEWS : Array = [LOCATIONS_LIST_VIEW, DIRECTORY_VIEW, HIERARCHY_TREE_VIEW];

		protected static const LOCATION : String = "Location";
		protected static const MODULE : String = "Module";
		protected static const CHANNEL : String = "Channel";
		protected static const SENSOR : String = "Sensor";
		protected static const HIERARCHY : String = "Hierarchy";

		protected static const TABS : Array = [LOCATION, MODULE, CHANNEL, SENSOR, HIERARCHY];


		public var service : AdminService;

		protected var modulesController : ModulesController;
		protected var channelsController : ChannelsController;
		protected var sensorsController : SensorsController;
		protected var hierarchyController : HierarchyController;
		protected var directoryController : DirectoryController;
		protected var treeController : TreeController;
		protected var locationsController : LocationController;
		protected var locationListController : LocationListController;
		protected var treeConstructorController : TreeConstructorController;

		public function MainBase() {
			super();
		}

		protected function setListeners() : void {
			directoryController.addEventListener(DirectoryEvent.CREATE_MODULE, onCreateModule);
			directoryController.addEventListener(DirectoryEvent.EDIT_MODULE, onEditModule);
			directoryController.addEventListener(DirectoryEvent.CREATE_CHANNEL, onCreateChannel);
			directoryController.addEventListener(DirectoryEvent.EDIT_CHANNEL, onEditChannel);
			directoryController.addEventListener(DirectoryEvent.CREATE_SENSOR, onCreateSensor);
			directoryController.addEventListener(DirectoryEvent.EDIT_SENSOR, onEditSensor);
			locationListController.addEventListener(LocationListEvent.CREATE_LOCATION, onCreateLocation);
			locationListController.addEventListener(LocationListEvent.EDIT_LOCATION, onEditLocation);
			treeController.addEventListener(TreeEvent.NODE_SELECTED, onNodeSelected);

			locationsController.addEventListener(LocationsEvent.LOCATION_CREATED, onLocationCreated);
			locationsController.addEventListener(RefreshEvent.DATA_UPDATED, onRefreshNeeded);
			modulesController.addEventListener(ModulesEvent.MODULE_CREATED, onModuleCreated);
			modulesController.addEventListener(RefreshEvent.DATA_UPDATED, onRefreshNeeded);
			channelsController.addEventListener(ChannelsEvent.CHANNEL_CREATED, onChannelCreated);
			channelsController.addEventListener(RefreshEvent.DATA_UPDATED, onRefreshNeeded);
			sensorsController.addEventListener(SensorsEvent.SENSOR_CREATED, onSensorCreated);
			hierarchyController.addEventListener(HierarchyEvent.NODE_CREATED, onNodeCreated);
			hierarchyController.addEventListener(HierarchyEvent.PARENT_CHANGED, onParentChanged);
			treeConstructorController.addEventListener(HierarchyEvent.PARENT_CHANGED, onParentChanged);
		}


		private function onRefreshNeeded(event : RefreshEvent) : void {
			treeConstructorController.refresh();
		}

		private function onParentChanged(event : HierarchyEvent) : void {
			treeController.changeParent(event.node, event.childNode);
		}

		private function onNodeCreated(event : HierarchyEvent) : void {
			treeController.addNode(event.node);
		}

		private function onSensorCreated(event : SensorsEvent) : void {
			directoryController.onSensorCreated(event.channel, event.sensor);
		}

		private function onChannelCreated(event : ChannelsEvent) : void {
			directoryController.onChannelCreated(event.module, event.channel);
		}

		private function onEditLocation(event : LocationListEvent) : void {
			locationsController.editLocation(event.location);
		}

		private function onCreateLocation(event : LocationListEvent) : void {
			locationsController.createNewLocation();
		}

		private function onLocationCreated(event : LocationsEvent) : void {
			locationListController.onLocationCreated(event.location);
		}

		private function onModuleCreated(event : ModulesEvent) : void {
			directoryController.onModuleCreated(event.module)
		}

		private function onCreateModule(event : DirectoryEvent) : void {
			modulesController.createNewModule();
			updateSelectedTab(TABS.indexOf(MODULE));
		}

		private function onEditModule(event : DirectoryEvent) : void {
			modulesController.editModule(event.module);
			updateSelectedTab(TABS.indexOf(MODULE));
		}

		private function onCreateChannel(event : DirectoryEvent) : void {
			modulesController.editModule(event.module);
			channelsController.createNewChannel(event.module);
			updateSelectedTab(TABS.indexOf(CHANNEL));
		}

		private function onEditChannel(event : DirectoryEvent) : void {
			modulesController.editModule(event.module);
			channelsController.editChannel(event.module, event.channel);
			sensorsController.editSensor(event.channel, event.sensor);
			updateSelectedTab(TABS.indexOf(CHANNEL));
		}

		private function onCreateSensor(event : DirectoryEvent) : void {
			sensorsController.createNewSensor(event.channel);
		}

		private function onEditSensor(event : DirectoryEvent) : void {
			sensorsController.editSensor(event.channel, event.sensor);
		}

		private function onNodeSelected(event : TreeEvent) : void {
			hierarchyController.editNode(event.node);
		}

		protected function updateSelectedTab(ind : int) : void {

		}

	}
}