package com.incheck.admin.service {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Module;
import com.incheck.admin.model.Sensor;

import mx.collections.ArrayCollection;

public class ModulesParser {

    public function parseModules(objects : ArrayCollection) : ArrayCollection {
        var result  : ArrayCollection = new ArrayCollection();
        for each (var moduleObj : Object in objects) {
            var module : Module = new Module();

            module.id = moduleObj.deviceId;
            module.serialNumber = (moduleObj.mac as String).split(":").join("");
            module.deviceID = moduleObj.description;
            module.maxChannels = moduleObj.nbrFastChannels;

            for each (var channelObj : Object in moduleObj.channels) {
                var channel : Channel = new Channel();

                channel.id = channelObj.channelId;
                channel.connectorNum = channelObj.deviceChannelId;
                channel.channelID = channelObj.description;
                channel.offset = channelObj.scOffset;
                channel.sensorId = channelObj.sensorId;
                channel.channelType = channelObj.measureType;

                module.children.addItem(channel);
            }

            if (module.maxChannels > module.children.length) {
                module.children.addItemAt(new Channel(), 0);
            }

            result.addItem(module);
        }
        return result;
    }

    public function parseSensors(objects : ArrayCollection) : ArrayCollection {
        var result : ArrayCollection = new ArrayCollection();

        for each (var sensorObj : Object in objects) {
            var sensor : Sensor = new Sensor();

            sensor.id = sensorObj.sensorId;
            sensor.sensorType = sensorObj.type;
            sensor.serialNumber = sensorObj.serialNumber;
            sensor.sensitivity = sensorObj.sensitivity;

            result.addItem(sensor);
        }

        return result;
    }
}
}
