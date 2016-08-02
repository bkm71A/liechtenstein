package com.incheck.admin.view.hierarchy {
import com.incheck.admin.model.TreeItem;
import com.incheck.admin.model.TreeNode;

import mx.collections.ArrayCollection;

public interface IHierarchy {
    function whenSaveNode(func : Function) : void;

    function whenDisconnectNode(func : Function) : void;

    function whenDisableNode(func : Function) : void;

    function whenChangeParent(func : Function) : void;

    function editNode(node : TreeItem) : void;

    function updateNodes(nodes : ArrayCollection) : void;
}
}
