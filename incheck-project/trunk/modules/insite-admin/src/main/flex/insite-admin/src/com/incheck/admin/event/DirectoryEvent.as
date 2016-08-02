package com.incheck.admin.event {
import com.incheck.admin.model.Channel;

import com.incheck.admin.model.Module;
import com.incheck.admin.model.Sensor;

import flash.events.Event;


public class DirectoryEvent extends Event {

    public static const CREATE_MODULE : String = "createModule";
    public static const EDIT_MODULE : String = "editModule";
    public static const CREATE_CHANNEL : String = "createChannel";
    public static const EDIT_CHANNEL : String = "editChannel";
    public static const CREATE_SENSOR : String = "createSensor";
    public static const EDIT_SENSOR : String = "editSensor";

    public var module : Module;
    public var channel : Channel;
    public var sensor : Sensor;

    public function DirectoryEvent(type : String) {
        super(type);
    }
}
}
