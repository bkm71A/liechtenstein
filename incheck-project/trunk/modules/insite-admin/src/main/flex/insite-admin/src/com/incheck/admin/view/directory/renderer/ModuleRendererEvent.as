package com.incheck.admin.view.directory.renderer {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Module;

import flash.events.Event;

public class ModuleRendererEvent extends Event {

    public static const MODULE_CLICKED : String = "moduleClicked";
    public static const CHANNEL_CLICKED : String = "channelClicked";

    public var module : Module;
    public var channel : Channel;

    public function ModuleRendererEvent(type : String) {
        super (type, true);
    }
}
}
