package com.incheck.admin.view.hierarchy {
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.TreeItem;
import com.incheck.admin.model.TreeNode;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;

public class HierarchyBase extends VBox implements IHierarchy {
    [Bindable]
    protected var node:TreeNode = new TreeNode();

    protected var nodes : ArrayCollection = new ArrayCollection();

    protected var filteredNodes : ArrayCollection = new ArrayCollection();

    public var availableChannels : ArrayCollection;


    private var whenSaveFunction : Function;
    private var whenDisableFunction : Function;
    private var whenDisconnectFunction : Function;
    private var whenChangeParentFunction : Function;


    public function HierarchyBase() {
        super();
    }

    protected function onSave(name : String): void {
        node.name = name;
        whenSaveFunction(node);
//        if (nodes.getItemIndex(node) == -1) {
//            nodes.addItem(node);
//        }
        node = new TreeNode();
    }

    protected function onDisconnect() : void {
        if (node.name != 'New'){
            whenDisconnectFunction(node);
        }
    }

    protected function onDisable() : void {
        if (node.name != 'New'){
            whenDisableFunction(node);
        }
    }

    protected function onSaveParent(parentOrChildNode : Object, isParent : Boolean) : void {
        if (isParent) {
            whenChangeParentFunction(parentOrChildNode, node);
        } else {
            whenChangeParentFunction(node, parentOrChildNode);
        }

    }

    public function editNode(node : TreeItem) : void {
        if (!(node is TreeNode)) return;
        this.node = node as TreeNode;

        filteredNodes.removeAll();
        lookThroughChilds(nodes, filteredNodes, node as TreeNode);
        for each (var channel : Channel in availableChannels) {
            filteredNodes.addItem(channel);
        }
    }

    private function lookThroughChilds(nodes : ArrayCollection, result : ArrayCollection, n : TreeNode) : void {
        for each (var node : TreeNode in nodes) {
            if (n != node) {
                result.addItem(node);
            }
            lookThroughChilds(node.children, result, n);
        }
    }

    public function updateNodes(nodes : ArrayCollection) : void {
        this.nodes = nodes;
    }

    protected function labelFunction(item : Object) : String {
        if (item is TreeNode) {
            return (item as TreeNode).name;
        } else if (item is Channel) {
            return (item as Channel).channelID;
        }
        return "";
    }

    public function whenSaveNode(func:Function):void {
        whenSaveFunction = func;
    }

    public function whenDisconnectNode(func:Function):void {
        whenDisconnectFunction = func;
    }

    public function whenDisableNode(func:Function):void {
        whenDisableFunction = func;
    }

    public function whenChangeParent(func : Function) : void {
        whenChangeParentFunction = func;
    }

}
}