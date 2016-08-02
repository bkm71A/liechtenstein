package com.incheck.admin.view.tree {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.TreeItem;
import com.incheck.admin.model.TreeNode;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.events.ListEvent;

public class TreeHierarchyBase extends VBox implements ITree {

    public var availableChannels : ArrayCollection;
    [Bindable]
    public var nodes : ArrayCollection;

    private var whenItemSelectedFunction : Function;


    public function TreeHierarchyBase() {
    }

    protected function labelFunction(item : Object) : String {
        if (item is TreeNode) {
            return (item as TreeNode).name;
        } else if (item is Channel) {
            return (item as Channel).channelID;
        }
        return "";
    }

    public function updateNodes(ndoes : ArrayCollection) : void {
        //this.nodes = nodes;
    }

    protected function onItemSelected(node : TreeItem) : void {
        whenItemSelectedFunction(node);
    }


    public function whenItemSelected(func:Function):void {
        whenItemSelectedFunction = func;
    }
}
}
