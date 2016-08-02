package com.incheck.admin.controller {
	import com.incheck.admin.event.AdminServiceEvent;
	import com.incheck.admin.event.LocationsEvent;
	import com.incheck.admin.event.RefreshEvent;
	import com.incheck.admin.model.Location;
	import com.incheck.admin.service.AdminService;
	import com.incheck.admin.view.location.ILocations;

	public class LocationController extends BaseController {
		private var view : ILocations;
		private var location : Location;

		public function LocationController(view : ILocations, service : AdminService) {
			this.service = service;
			this.view = view;
			this.view.whenSaveLocation(onSaveLocation);
			isNew = true;
		}

		public function createNewLocation() : void {
			isNew = true;
			this.location = new Location();
			view.editLocation(location);
		}

		public function editLocation(location : Location) : void {
			isNew = false;
			this.location = location;
			view.editLocation(location);
		}

		private function onSaveLocation(location : Location) : void {
			service.addEventListener(AdminServiceEvent.LOCATION_SAVED, onLocationSaved);
			service.saveLocation(location.id, location.description);
			this.location = location;
		}

		private function onLocationSaved(serviceEvent : AdminServiceEvent) : void {
			service.removeEventListener(AdminServiceEvent.LOCATION_SAVED, onLocationSaved);
			if (isNew) {
				var event : LocationsEvent = new LocationsEvent(LocationsEvent.LOCATION_CREATED);
				location.id = serviceEvent.newId;
				event.location = location;
				dispatchEvent(event);
			}
			isNew = false;
			var refreshEvent : RefreshEvent = new RefreshEvent(RefreshEvent.DATA_UPDATED);
			dispatchEvent(refreshEvent);
		}
	}
}
