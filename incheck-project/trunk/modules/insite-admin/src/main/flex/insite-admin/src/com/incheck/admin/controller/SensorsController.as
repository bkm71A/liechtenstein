package com.incheck.admin.controller {
import com.incheck.admin.event.AdminServiceEvent;
import com.incheck.admin.event.SensorsEvent;
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Sensor;
import com.incheck.admin.service.AdminService;
import com.incheck.admin.view.sensors.ISensors;

import mx.collections.ArrayCollection;

public class SensorsController extends BaseController {
    private var view:ISensors;

    private var sensors : ArrayCollection;

    private var sensor : Sensor;
    private var channel: Channel;

    public function SensorsController(view:ISensors, service : AdminService) {
        this.service = service;
        this.view = view;
        this.view.whenSaveSensor(onSaveSensor);
    }


    public function createNewSensor(channel : Channel) : void {
        isNew = true;
        this.channel = channel;
        this.sensor = new Sensor();
        view.editSensor(this.channel, this.sensor);
    }

    public function editSensor(channel : Channel, sensor : Sensor) : void {
        isNew = false;
        this.channel = channel;
        this.sensor = sensor ? sensor : new Sensor();
        view.editSensor(this.channel, this.sensor);
    }

    private function onSaveSensor(channel : Channel, sensor:Sensor):void {
        this.channel = channel;
        this.sensor = sensor;
        service.addEventListener(AdminServiceEvent.SENSOR_SAVED, onSensorSaved);
        service.saveSensor(sensor.id, sensor.serialNumber, sensor.sensorType, sensor.sensitivity, channel.id);
    }

    private function onSensorSaved(serviceEvent : AdminServiceEvent) : void {
        service.removeEventListener(AdminServiceEvent.SENSOR_SAVED, onSensorSaved);
        var event : SensorsEvent = new SensorsEvent(SensorsEvent.SENSOR_CREATED);
        event.sensor = sensor;
        event.channel = channel;
        dispatchEvent(event);
        isNew = false;
    }

}
}