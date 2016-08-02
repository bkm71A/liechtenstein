package com.incheck.admin.controller {
	import com.incheck.admin.event.AdminServiceEvent;
	import com.incheck.admin.event.DirectoryEvent;
	import com.incheck.admin.model.Channel;
	import com.incheck.admin.model.Module;
	import com.incheck.admin.model.Sensor;
	import com.incheck.admin.service.AdminService;
	import com.incheck.admin.view.directory.IDirectory;

	import mx.collections.ArrayCollection;

	public class DirectoryController extends BaseController {

		private var view : IDirectory;

		public var modules : ArrayCollection;
		private var sensors : ArrayCollection;
		public var availableChannels : ArrayCollection;
		private var dataIsReceived : Boolean = false;

		public function DirectoryController(view : IDirectory, modules : ArrayCollection, service : AdminService, availableChannels : ArrayCollection) {
			this.service = service;
			this.view = view;
			this.view.whenModuleSelected(onModuleSelected);
			this.view.whenChannelSelected(onChannelSelected);
			this.view.updateModules(modules);
			this.modules = modules;
			this.availableChannels = availableChannels;

			service.addEventListener(AdminServiceEvent.MODULES_RECEIVED, onGetModules);
			service.getModules();
			service.addEventListener(AdminServiceEvent.SENSORS_RECEIVED, onSensorsReceived);
			service.getSensors();
		}

		private function onGetModules(event : AdminServiceEvent) : void {
			this.modules = event.modules;
			this.modules.addItemAt(new Module(), 0);
			updateAvailableChannels();
			view.updateModules(this.modules);
			if (dataIsReceived) {
				setSensorsToChannels();
			}
			dataIsReceived = true;
		}

		private function onSensorsReceived(event : AdminServiceEvent) : void {
			sensors = event.sensors;
			if (dataIsReceived) {
				setSensorsToChannels();
			}
			dataIsReceived = true;
		}

		private function setSensorsToChannels() : void {
			for each (var module : Module in modules) {
				for each (var channel : Channel in module.children) {
					if (channel.sensorId) {
						channel.sensor = getSensor(channel.sensorId);
					}
				}
			}
		}

		private function getSensor(id : int) : Sensor {
			for each (var sensor : Sensor in sensors) {
				if (sensor.id == id) {
					return sensor;
				}
			}
			return null;
		}

		private function updateAvailableChannels() : void {
			for each (var module : Module in modules) {
				for each (var channel : Channel in module.children) {
					if (channel.id) {
						availableChannels.addItem(channel);
					}
				}
			}
		}

		private function onChannelSelected(module : Module, channel : Channel = null) : void {
			var event : DirectoryEvent;
			if (channel) {
				event = new DirectoryEvent(DirectoryEvent.EDIT_CHANNEL);
				event.channel = channel;
				event.sensor = channel.sensor;
			} else {
				event = new DirectoryEvent(DirectoryEvent.CREATE_CHANNEL);
			}
			event.module = module;
			dispatchEvent(event);
		}

		private function onModuleSelected(module : Module = null) : void {
			var event : DirectoryEvent;
			if (module) {
				event = new DirectoryEvent(DirectoryEvent.EDIT_MODULE);
				event.module = module;
			} else {
				event = new DirectoryEvent(DirectoryEvent.CREATE_MODULE);
			}
			dispatchEvent(event);
		}

		public function onSensorCreated(channel : Channel, sensor : Sensor) : void {
			channel.sensor = sensor;
		}

		public function onChannelCreated(module : Module, channel : Channel) : void {
			module.children.addItem(channel);
			if (module.children.length > module.maxChannels) {
				module.children.removeItemAt(0);
			}
			availableChannels.addItem(channel);
		}

		public function onModuleCreated(module : Module) : void {
			modules.addItem(module);
			module.children.addItem(new Channel());
		}
	}
}
