package com.incheck.admin.view.modules {
import com.incheck.admin.model.Module;

import mx.containers.VBox;
import mx.controls.Alert;

public class ModulesBase extends VBox implements IModules {
    [Bindable]
    protected var device:Module = new Module();

    private var whenSaveFunction:Function;

    protected var channelsNumber : Array = [1, 2, 3, 4, 5, 6, 7, 8];

    public function ModulesBase() {
        super();
    }

    public function whenSaveModule(func:Function):void {
        whenSaveFunction = func;
    }

    public function editModule(module:Module):void {
        device = module;
    }

    protected function onSaveModule(serialNumber:String, deviceId:String, maxChannels:Number):void {
        if (serialNumber.length != 12) {
            Alert.show("Incorrect Serial number");
            return;
        }
        device.serialNumber = serialNumber;
        device.deviceID = deviceId;
        device.maxChannels = maxChannels;
        whenSaveFunction(device);
    }
}
}