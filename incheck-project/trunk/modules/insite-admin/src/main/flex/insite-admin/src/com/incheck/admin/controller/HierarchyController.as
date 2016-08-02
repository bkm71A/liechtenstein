package com.incheck.admin.controller {
import com.incheck.admin.event.AdminServiceEvent;
import com.incheck.admin.event.HierarchyEvent;
import com.incheck.admin.model.TreeItem;
import com.incheck.admin.model.TreeNode;
import com.incheck.admin.service.AdminService;
import com.incheck.admin.view.hierarchy.IHierarchy;

public class HierarchyController extends BaseController {

    private var view:IHierarchy;
    private var node:TreeItem;

    public function HierarchyController(view:IHierarchy, service : AdminService) {
        this.service = service;
        this.view = view;
        this.view.whenSaveNode(onSaveNode);
        this.view.whenDisableNode(onDisableNode);
        this.view.whenDisconnectNode(onDisconnectNode);
        this.view.whenChangeParent(onChangeParent);
        isNew = true;


        service.addEventListener(AdminServiceEvent.NODES_RECEIVED, onNodesReceived);
    }

    private function onNodesReceived(event : AdminServiceEvent) : void {
        view.updateNodes(event.nodes);
    }

    public function editNode(node : TreeItem): void {
        isNew = false;
        this.node = node;
        view.editNode(node);
    }

    public function onSaveNode(node : TreeNode) : void {
        this.node = node;
        service.addEventListener(AdminServiceEvent.NODE_SAVED, onNodeSaved);
        service.saveTreeNode(node.id,
                node.parent ? node.parent.id : 0,
                node.location ? node.location.id : 0,
                node.module ? node.module.id : 0,
                node.channel ? node.channel.id : NaN,
                node.state,
                node.name,
                node.type);
    }

    private function onNodeSaved(serviceEvent : AdminServiceEvent) : void {
        service.removeEventListener(AdminServiceEvent.NODE_SAVED, onNodeSaved);
        if (isNew) {
            var event : HierarchyEvent = new HierarchyEvent(HierarchyEvent.NODE_CREATED);
            event.node = node as TreeNode;
            event.node.id = serviceEvent.newId
            dispatchEvent(event);
        }
        isNew = true;
    }

    private function onDisableNode(node : TreeNode) : void {

    }

    private function onDisconnectNode(node : TreeNode) : void {

    }

    private function onChangeParent(parentNode : TreeNode, childNode : TreeItem) : void {
        var event : HierarchyEvent = new HierarchyEvent(HierarchyEvent.PARENT_CHANGED);
        event.node = parentNode;
        event.childNode = childNode;
        dispatchEvent(event);
    }

}
}
