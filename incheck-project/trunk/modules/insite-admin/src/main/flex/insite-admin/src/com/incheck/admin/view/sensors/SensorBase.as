package com.incheck.admin.view.sensors {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Sensor;

import mx.collections.ArrayCollection;
import mx.containers.VBox;

public class SensorBase extends VBox implements ISensors {
    [Bindable]
    protected var sensor:Sensor = new Sensor();
    [Bindable]
    protected var channel:Channel;

    protected const sensorTypes : Array = ["OTR", "SIM"];

    public var availableChannels : ArrayCollection = new ArrayCollection();

    private var whenSaveFunction:Function;

    public function SensorBase() {
        super();
    }

    public function whenSaveSensor(func:Function):void {
        whenSaveFunction = func;
    }

    protected function onSaveSensor(sensorType : String, selectedChannel : Channel, serialNumber : String, sensitivity : String):void {
        sensor.sensorType = sensorType;
        sensor.serialNumber = serialNumber;
        sensor.sensitivity = Number(sensitivity);
        whenSaveFunction(selectedChannel, sensor);
    }

    public function editSensor(channel : Channel, sensor:Sensor) {
        this.channel = channel;
        this.sensor = sensor;
    }
}
}