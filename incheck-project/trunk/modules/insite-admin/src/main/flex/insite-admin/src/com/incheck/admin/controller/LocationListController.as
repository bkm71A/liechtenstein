package com.incheck.admin.controller {
import com.incheck.admin.event.AdminServiceEvent;
import com.incheck.admin.event.DirectoryEvent;
import com.incheck.admin.event.LocationListEvent;
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Location;
import com.incheck.admin.model.Module;
import com.incheck.admin.service.AdminService;
import com.incheck.admin.view.locationlist.ILocationList;

import mx.collections.ArrayCollection;

public class LocationListController extends BaseController{

    private var view:ILocationList;

    private var locations : ArrayCollection;

    public function LocationListController(view:ILocationList, locations:ArrayCollection, service : AdminService) {
        this.service = service;
        this.view = view;
        this.view.whenLocationSelected(onLocationSelected);
        this.view.updateLocations(locations);
        this.locations = locations;

        service.addEventListener(AdminServiceEvent.LOCATIONS_RECEIVED, onGetLocations);
        service.getLocations();
    }

    private function onLocationSelected(location : Location = null) : void {
        var event : LocationListEvent;
        if (location) {
            event = new LocationListEvent(LocationListEvent.EDIT_LOCATION);
            event.location = location;
        } else {
            event = new LocationListEvent(LocationListEvent.CREATE_LOCATION);
        }
        dispatchEvent(event);
    }

    private function onGetLocations(event : AdminServiceEvent) : void {
        this.locations = event.locations;
        this.locations.addItemAt(new Location(), 0);
        view.updateLocations(this.locations);
    }

    public function onLocationCreated(location : Location):void {
        locations.addItem(location);
    }
}
}
