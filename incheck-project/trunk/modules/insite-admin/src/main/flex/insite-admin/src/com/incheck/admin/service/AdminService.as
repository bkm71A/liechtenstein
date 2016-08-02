package com.incheck.admin.service {
	import com.incheck.admin.event.AdminServiceEvent;

	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;

	public class AdminService extends EventDispatcher {

		private function errorCallBack(event : FaultEvent) : void {
			Alert.show(event.fault.faultDetail);
		}

		public function getModules() : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, getModulesCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.getDevices();
		}

		private function getModulesCallBack(event : ResultEvent) : void {
			var modulesParser : ModulesParser = new ModulesParser();
			var modules : ArrayCollection = modulesParser.parseModules(event.result as ArrayCollection);
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.MODULES_RECEIVED);
			resultEvent.modules = modules;
			dispatchEvent(resultEvent);
		}

		public function saveModule(id : int, serialNumber : String, deviceId : String, maxChannels : uint) : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, saveModuleCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.saveDevice(isNaN(id) ? 0 : id, convertToMacAddress(serialNumber), deviceId, maxChannels);
		}

		private function convertToMacAddress(serialNumber : String) : String {
			return serialNumber.charAt(0) + serialNumber.charAt(1) + ":" +
					serialNumber.charAt(2) + serialNumber.charAt(3) + ":" +
					serialNumber.charAt(4) + serialNumber.charAt(5) + ":" +
					serialNumber.charAt(6) + serialNumber.charAt(7) + ":" +
					serialNumber.charAt(8) + serialNumber.charAt(9) + ":" +
					serialNumber.charAt(10) + serialNumber.charAt(11);
		}

		private function saveModuleCallBack(event : ResultEvent) : void {
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.MODULE_SAVED);
			resultEvent.newId = event.result as Number;
			dispatchEvent(resultEvent);
		}

		public function saveChannel(id : int, deviceId : int, channelId : String, channelType : String, deviceChannelId : int, offset : Number) : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, saveChannelCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.saveChannel(isNaN(id) ? 0 : id, deviceId, channelId, getChannelType(channelType), channelType, deviceChannelId, offset);
		}

		private function getChannelType(measureType : String) : int {
			if (measureType == "Vib") return 1;
			else return 2;
		}

		private function saveChannelCallBack(event : ResultEvent) : void {
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.CHANNEL_SAVED);
			resultEvent.newId = event.result as Number;
			dispatchEvent(resultEvent);
		}

		public function getSensors() : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, getSensorsCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.getSensors();
		}

		private function getSensorsCallBack(event : ResultEvent) : void {
			var modulesParser : ModulesParser = new ModulesParser();
			var sensors : ArrayCollection = modulesParser.parseSensors(event.result as ArrayCollection);
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.SENSORS_RECEIVED);
			resultEvent.sensors = sensors;
			dispatchEvent(resultEvent);
		}

		public function saveSensor(id : int, serialNumber : String, sensorType : String, sensitivity : Number, channelId : int) : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, saveSensorCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			var vendorId : int = 1;
			ro.saveSensor(isNaN(id) ? 0 : id, serialNumber, vendorId, sensorType, sensitivity, channelId);
		}

		private function saveSensorCallBack(event : ResultEvent) : void {
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.SENSOR_SAVED);
			resultEvent.newId = event.result as Number;
			dispatchEvent(resultEvent);
		}

		public function getTreeNodes() : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, getTreeNodesCallback);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.getTreeNodes();
		}

		private function getTreeNodesCallback(event : ResultEvent) : void {
			var nodesParser : TreeNodesParser = new TreeNodesParser();
			var nodes : ArrayCollection = nodesParser.parseTreeNodes(event.result as ArrayCollection);
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.NODES_RECEIVED);
			resultEvent.nodes = nodes;
			dispatchEvent(resultEvent);
		}

		public function saveTreeNode(id : int, parentId : int, locationId : int, machineId : int, channelId : int, status : int, name : String, type : String) : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, saveTreeNodeCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.saveTreeNode(parentId, locationId, machineId, channelId, status, name, "", type, id);
		}

		private function saveTreeNodeCallBack(event : ResultEvent) : void {
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.NODE_SAVED);
			resultEvent.newId = event.result as Number;
			dispatchEvent(resultEvent);
		}

		public function saveLocation(id : int, description : String) : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, saveLocationCallBack);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.saveLocation(id, description);
		}

		private function saveLocationCallBack(event : ResultEvent) : void {
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.LOCATION_SAVED);
			resultEvent.newId = event.result as Number;
			dispatchEvent(resultEvent);
		}

		public function getLocations() : void {
			var ro : RemoteObject = new RemoteObject("adminService");
			ro.addEventListener(ResultEvent.RESULT, getLocationsCallback);
			ro.addEventListener(FaultEvent.FAULT, errorCallBack);
			ro.getLocations();
		}

		private function getLocationsCallback(event : ResultEvent) : void {
			var locationsParser : LocationParser = new LocationParser();
			var locations : ArrayCollection = locationsParser.parseLocations(event.result as ArrayCollection);
			var resultEvent : AdminServiceEvent = new AdminServiceEvent(AdminServiceEvent.LOCATIONS_RECEIVED);
			resultEvent.locations = locations;
			dispatchEvent(resultEvent);
		}
	}
}