package com.incheck.admin.view.directory {
import com.incheck.admin.model.Module;

import mx.controls.treeClasses.DefaultDataDescriptor;

public class DirectoryTreeDataDescriptor extends DefaultDataDescriptor{
    public function DirectoryTreeDataDescriptor() {
    }

    public override function isBranch(node:Object, model:Object=null) : Boolean {
        var branch : Boolean = false;
        if (node is Module) { // && !(node as TreeNode).channel) {
            branch = true;
        } else {
            branch = false;
        }

        return branch;
    }
}
}
