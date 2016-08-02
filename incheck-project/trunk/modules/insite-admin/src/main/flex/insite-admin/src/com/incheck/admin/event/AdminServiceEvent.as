package com.incheck.admin.event {
import flash.events.Event;

import mx.collections.ArrayCollection;

public class AdminServiceEvent extends Event {

    public static const MODULES_RECEIVED : String = "modulesReceived";
    public static const MODULE_SAVED : String = "moduleSaved";
    public static const CHANNEL_SAVED : String = "channelSaved";
    public static const SENSORS_RECEIVED : String = "sensorsReceived";
    public static const SENSOR_SAVED : String = "sensorSaved";

    public static const NODES_RECEIVED : String = "nodesReceived";
    public static const NODE_SAVED : String = "nodeSaved";

    public static const LOCATIONS_RECEIVED : String = "locationsReceived";
    public static const LOCATION_SAVED : String = "locationSaved";

    public var modules : ArrayCollection;
    public var sensors : ArrayCollection;
    public var locations : ArrayCollection;
    public var newId : int;
    public var nodes : ArrayCollection;

    public function AdminServiceEvent(type : String) {
        super(type)
    }
}
}
