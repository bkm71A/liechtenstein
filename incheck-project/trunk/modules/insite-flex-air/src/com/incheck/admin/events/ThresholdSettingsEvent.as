package com.incheck.admin.events {
import com.incheck.common.EventThreshold;

import flash.events.Event;

public class ThresholdSettingsEvent extends Event {

    public static const DELETE_THRESHOLD : String = "deleteThreshold";
    public static const EDIT_THRESHOLD : String = "editThreshold";

    private var _eventThreshold : EventThreshold;

    public function ThresholdSettingsEvent(type : String, item : EventThreshold) {
        super(type);
        _eventThreshold = item;
    }

    public function get eventThreshold():EventThreshold {
        return _eventThreshold;
    }
}
}