package com.incheck.admin.view.channels {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Module;

import mx.containers.VBox;

public class ChannelsBase extends VBox implements IChannels {
    [Bindable]
    protected var channel:Channel;
    [Bindable]
    protected var device:Module;

    protected const channelTypes : Array = ["Tem", "Vib"];

    protected const connectorTypes : Array = ["S1-A",
"S1-B",
"S2-A",
"S2-B",
"S3-A",
"S3-B",
"S4-A",
"S4-B",
"S5-A",
"S5-B",
"S6-A",
"S6-B",
"S7-A",
"S7-B",
"S8-A",
"S8-B"
];

    private var whenSaveFunction:Function;

    public function ChannelsBase() {
        super();
    }

    public function whenSaveChannel(func:Function):void {
        whenSaveFunction = func;
    }

    protected function onSaveChannel(channelType:String, connectorNum:String, channelId:String, offset: String):void {
        channel.channelType = channelType;
        channel.connectorNum = connectorTypes.indexOf(connectorNum) + 1;
        channel.channelID = channelId;
        channel.offset = Number(offset);
        whenSaveFunction(device, channel);
    }

    [Bindable]
    protected function connectorNumValue(channel : Channel) : String {
        if (!channel) return null;
        return connectorTypes[channel.connectorNum - 1];
    }

    public function editChannel(module : Module, channel:Channel):void {
        device = module;
        this.channel = channel;
    }
}
}