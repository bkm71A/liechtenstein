package com.incheck.admin.event {
import com.incheck.admin.model.Location;

import flash.events.Event;

public class LocationListEvent extends Event {

    public static const CREATE_LOCATION : String = "createLocation";
    public static const EDIT_LOCATION : String = "editLocation";

    public var location : Location;
    public function LocationListEvent(type:String) {
        super(type)
    }
}
}
