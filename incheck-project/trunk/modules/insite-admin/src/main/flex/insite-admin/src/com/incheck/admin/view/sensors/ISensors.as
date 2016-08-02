package com.incheck.admin.view.sensors {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Sensor;

public interface ISensors {

    function whenSaveSensor(func:Function):void;

    function editSensor(channel : Channel, sensor : Sensor);

}
}