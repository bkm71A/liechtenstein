package com.incheck.admin.event {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Sensor;

import flash.events.Event;

public class SensorsEvent extends Event {

    public static const SENSOR_CREATED : String = "sensorCreated";

    public var sensor : Sensor;

    public var channel : Channel;

    public function SensorsEvent(type : String) {
        super(type)
    }
}
}
