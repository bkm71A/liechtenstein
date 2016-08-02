package com.incheck.admin.event {
import com.incheck.admin.model.Module;

import flash.events.Event;

public class ModulesEvent extends Event {

    public static const MODULE_CREATED:String = "moduleCreated";

    public var module : Module;

    public function ModulesEvent(type : String) {
        super(type);
    }
}
}
