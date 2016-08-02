package com.incheck.admin.service {
import com.incheck.admin.model.Location;

import mx.collections.ArrayCollection;

public class LocationParser {
    public function parseLocations(objects : ArrayCollection) : ArrayCollection {
        var result : ArrayCollection = new ArrayCollection();

        for each (var locationObj : Object in objects) {
            var location : Location = new Location();

            location.id = locationObj.locationId;
            location.description = locationObj.description;

            result.addItem(location);
        }

        return result;
    }

}
}
