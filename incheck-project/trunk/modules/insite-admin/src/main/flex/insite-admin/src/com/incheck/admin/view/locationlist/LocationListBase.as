package com.incheck.admin.view.locationlist {
import com.incheck.admin.model.Location;
import com.incheck.admin.view.directory.renderer.ModuleRendererEvent;

import mx.collections.ArrayCollection;
import mx.containers.VBox;

public class LocationListBase extends VBox implements ILocationList {

     [Bindable]
    protected var locations : ArrayCollection;

    private var whenLocationSelectedFunction : Function;

    protected function onLocationClicked(location : Location) : void {
        var ind : uint = locations.getItemIndex(location);
        whenLocationSelectedFunction (ind ? location : null);
    }
    public function whenLocationSelected(func:Function):void {
        whenLocationSelectedFunction = func;
    }

    public function updateLocations(locations:ArrayCollection):void {
        this.locations = locations
    }
}
}
