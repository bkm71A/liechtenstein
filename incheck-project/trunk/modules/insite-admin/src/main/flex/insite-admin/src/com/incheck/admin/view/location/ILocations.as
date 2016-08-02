package com.incheck.admin.view.location {
import com.incheck.admin.model.Location;

public interface ILocations {
        function whenSaveLocation (func:Function) : void;

        function editLocation(location : Location) : void;
}
}
