package com.incheck.admin.event {
import com.incheck.admin.model.Channel;

import com.incheck.admin.model.Module;

import flash.events.Event;

public class ChannelsEvent extends Event {

    public static const CHANNEL_CREATED : String = "channelCreated";

    public var channel:Channel;
    public var module : Module;

    public function ChannelsEvent(type : String) {
        super(type)
    }
}
}
