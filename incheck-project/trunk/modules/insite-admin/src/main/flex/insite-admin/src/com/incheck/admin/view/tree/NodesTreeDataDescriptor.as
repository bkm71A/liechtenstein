package com.incheck.admin.view.tree {
import com.incheck.admin.model.TreeNode;

import mx.controls.treeClasses.DefaultDataDescriptor;

public class NodesTreeDataDescriptor extends DefaultDataDescriptor {
    public function NodesTreeDataDescriptor() {
    }

    public override function isBranch(node:Object, model:Object=null) : Boolean {
        var branch : Boolean = false;
        if ((node is TreeNode) && !(node as TreeNode).channel) {
            branch = true;
        } else {
            branch = false;
        }

        return branch;
    }
}
}
