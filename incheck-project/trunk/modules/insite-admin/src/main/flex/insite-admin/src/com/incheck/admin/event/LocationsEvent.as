package com.incheck.admin.event {
import com.incheck.admin.model.Location;

import flash.events.Event;

public class LocationsEvent extends Event {
    public static const LOCATION_CREATED : String = "locationCreated";
    public var location : Location;

    public function LocationsEvent(type : String) {
        super(type);
    }
}
}
