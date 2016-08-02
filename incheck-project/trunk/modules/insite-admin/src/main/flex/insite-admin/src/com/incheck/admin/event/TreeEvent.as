package com.incheck.admin.event {
import com.incheck.admin.model.TreeItem;
import com.incheck.admin.model.TreeNode;

import flash.events.Event;

public class TreeEvent extends Event{

    public static const NODE_SELECTED : String = "nodeSelected";

    public var node : TreeItem;


    public function TreeEvent(type : String) {
        super(type);
    }
}
}
