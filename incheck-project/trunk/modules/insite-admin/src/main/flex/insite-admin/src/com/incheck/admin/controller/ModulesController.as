package com.incheck.admin.controller {
	import com.incheck.admin.event.AdminServiceEvent;
	import com.incheck.admin.event.ModulesEvent;
	import com.incheck.admin.event.RefreshEvent;
	import com.incheck.admin.model.Module;
	import com.incheck.admin.service.AdminService;
	import com.incheck.admin.view.modules.IModules;

	public class ModulesController extends BaseController {
		private var view : IModules;
		private var module : Module;

		public function ModulesController(view : IModules, service : AdminService) {
			this.service = service;
			this.view = view;
			this.view.whenSaveModule(onSaveModule);
			isNew = true;
		}

		public function createNewModule() : void {
			isNew = true;
			module = new Module();
			view.editModule(module);
		}

		public function editModule(module : Module) : void {
			isNew = false;
			this.module = module;
			view.editModule(module);
		}

		private function onSaveModule(module : Module) : void {
			service.addEventListener(AdminServiceEvent.MODULE_SAVED, onModuleSaved);
			service.saveModule(module.id, module.serialNumber, module.deviceID, module.maxChannels);
		}

		private function onModuleSaved(serviceEvent : AdminServiceEvent) : void {
			service.removeEventListener(AdminServiceEvent.MODULE_SAVED, onModuleSaved);
			if (isNew) {
				var event : ModulesEvent = new ModulesEvent(ModulesEvent.MODULE_CREATED);
				module.id = serviceEvent.newId;
				event.module = module;
				dispatchEvent(event);
			}
			isNew = false;
			var refreshEvent : RefreshEvent = new RefreshEvent(RefreshEvent.DATA_UPDATED);
			dispatchEvent(refreshEvent);
		}
	}
}