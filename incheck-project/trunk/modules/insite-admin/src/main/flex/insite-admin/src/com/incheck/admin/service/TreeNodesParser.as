package com.incheck.admin.service {
import com.incheck.admin.model.TreeNode;

import mx.collections.ArrayCollection;

public class TreeNodesParser {
    public function parseTreeNodes(objects : ArrayCollection) : ArrayCollection {
        var result : ArrayCollection = new ArrayCollection();

        var node : TreeNode;

        var temp : ArrayCollection = new ArrayCollection();
        for each (var nodeObj : Object in objects) {
            node = new TreeNode();

            node.id = nodeObj.treenodeId;
            node.name = nodeObj.name;
            node.state = nodeObj.status;
            node.type = nodeObj.treenodeType;
            node.parentId = nodeObj.parentId;
            node.channelId = nodeObj.channelId;
            temp.addItem(node);
        }

        for each (node in temp) {
            if (node.parentId == 0) {
                result.addItem(node);
            }
        }

        for each (node in temp) {
            for each (var node1 : TreeNode in temp) {
                if (node.parentId == node1.id) {
                    node.parent = node1;
                    node1.children.addItem(node);
                }
            }
        }

        return result;
    }
}
}
