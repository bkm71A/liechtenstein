package com.incheck.admin.view.location {
import com.incheck.admin.model.Location;

import mx.containers.VBox;

public class LocationsBase extends VBox implements ILocations {
    [Bindable]
    protected var location : Location = new Location();

    private var whenSaveFunction:Function;


    public function LocationsBase() {
        super();
    }


    public function whenSaveLocation(func:Function):void {
        whenSaveFunction = func;
    }

    protected function onSaveLocation(description : String) : void {
        location.description = description;
        whenSaveFunction(location);
    }

    public function editLocation(location:Location):void {
        this.location = location;
    }
}
}
