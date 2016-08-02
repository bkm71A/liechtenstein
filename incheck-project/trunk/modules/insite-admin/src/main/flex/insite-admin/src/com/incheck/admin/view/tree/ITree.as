package com.incheck.admin.view.tree {
import com.incheck.admin.model.TreeNode;

import mx.collections.ArrayCollection;

public interface ITree {
    function updateNodes(nodes : ArrayCollection) : void;
    function whenItemSelected(func : Function) : void
}
}
