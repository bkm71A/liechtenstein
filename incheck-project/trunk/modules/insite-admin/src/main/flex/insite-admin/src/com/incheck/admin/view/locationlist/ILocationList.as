package com.incheck.admin.view.locationlist {
import mx.collections.ArrayCollection;

public interface ILocationList {
    function whenLocationSelected (func : Function) : void;

    function updateLocations(locations : ArrayCollection) : void;

}
}
