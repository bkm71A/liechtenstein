package com.incheck.admin.view.channels {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Module;

public interface IChannels {
    function whenSaveChannel(func:Function):void;

    function editChannel(module : Module, channel:Channel) : void;
}
}