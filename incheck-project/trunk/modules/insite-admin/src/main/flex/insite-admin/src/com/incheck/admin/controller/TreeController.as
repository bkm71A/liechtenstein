package com.incheck.admin.controller {
import com.incheck.admin.event.AdminServiceEvent;
import com.incheck.admin.event.TreeEvent;
import com.incheck.admin.model.Channel;
import com.incheck.admin.model.Location;
import com.incheck.admin.model.Module;
import com.incheck.admin.model.TreeItem;
import com.incheck.admin.model.TreeNode;
import com.incheck.admin.service.AdminService;
import com.incheck.admin.view.tree.ITree;

import mx.collections.ArrayCollection;

public class TreeController extends BaseController {

		private var view : ITree;

		private var nodes : ArrayCollection;
		private var tmpNodes : ArrayCollection = new ArrayCollection();

		private var modules : ArrayCollection;
		private var locations : ArrayCollection;

		private var dataReceived : int = 0;

        private var parentToSave : TreeNode;
        private var nodeToSave : TreeNode;

		public function TreeController(view : ITree, nodes : ArrayCollection, service : AdminService) {
			this.service = service;
			this.view = view;
			this.nodes = nodes;
			this.view.whenItemSelected(onItemSelected);
			this.view.updateNodes(nodes);

			service.addEventListener(AdminServiceEvent.MODULES_RECEIVED, onGetModules);
			service.addEventListener(AdminServiceEvent.NODES_RECEIVED, onGetNodes);
			service.addEventListener(AdminServiceEvent.LOCATIONS_RECEIVED, onGetLocations);
			service.getTreeNodes();
		}

		private function onGetNodes(event : AdminServiceEvent) : void {
			if (dataReceived == 2) {
				updateChildrenNodes(event.nodes);
				nodes.addAll(event.nodes);
			} else {
				tmpNodes.addAll(event.nodes);
			}
			dataReceived++;
		}

		private function onGetModules(event : AdminServiceEvent) : void {
			modules = event.modules;
			if (dataReceived == 2) {
				updateChildrenNodes(tmpNodes);
				nodes.addAll(tmpNodes);
			}
			dataReceived++;
		}

        private function onGetLocations(event : AdminServiceEvent) : void {
            locations = event.locations;
			if (dataReceived == 2) {
				updateChildrenNodes(tmpNodes);
				nodes.addAll(tmpNodes);
			}
        }

		private function updateChildrenNodes(nodes : ArrayCollection) : void {
			for each (var node : TreeNode in nodes) {
				if (node.channelId) {
					for each (var module : Module in modules) {
						for each (var channel : Channel in module.children) {
							if (node.channelId == channel.id) {
								node.channel = channel;
							}
						}
					}
				}
                if (node.moduleId) {
                    for each (var module : Module in modules) {
                        if (node.moduleId == module.id) {
                            node.module = module;
                        }
					}
                }
                if (node.locationId) {
                    for each (var location : Location in locations) {
                        if (node.locationId == location.id) {
                            node.location = location;
                        }
					}
                }

                updateChildrenNodes(node.children);
			}
		}

		private function onItemSelected(node : TreeItem) : void {
			var event : TreeEvent = new TreeEvent(TreeEvent.NODE_SELECTED);
			event.node = node;
			dispatchEvent(event);
		}

		public function addNode(node : TreeNode) : void {
			nodes.addItem(node);
		}

		public function changeParent(parentNode : TreeNode, childNode : Object) : void {
			var previousParent : TreeNode;
			if (childNode.hasOwnProperty("parent")) {
				previousParent = childNode.parent;
			}
			var ind : int;
			if (previousParent) {
//				if (childNode is Channel) {
//					ind = findChannelNodeIndex(previousParent.children, childNode as Channel);
//				} else {
				ind = previousParent.children.getItemIndex(childNode);
//				}
				if (ind >= 0) {
					previousParent.children.removeItemAt(ind);
				}
			} else {
				ind = nodes.getItemIndex(childNode);
				if (ind >= 0) {
					nodes.removeItemAt(ind);
				}
			}
			var subNode : TreeNode;
			if (childNode is Channel) {
				var channel : Channel = childNode as Channel;
                subNode = new TreeNode();
				subNode.name = channel.channelID;
				subNode.channel = channel;
				subNode.parent = parentNode;
				subNode.type = TreeNode.NODE_CHANNEL;
				parentNode.children.addItem(subNode);
			} else if (childNode is Module) {
				var module : Module = childNode as Module;
                subNode = new TreeNode();
				subNode.name = module.deviceID;
				subNode.module = module;
				subNode.parent = parentNode;
				subNode.type = TreeNode.NODE_MACHINE;
				parentNode.children.addItem(subNode);
			} else if (childNode is Location) {
				var location : Location = childNode as Location;
                subNode = new TreeNode();
				subNode.name = location.description;
				subNode.location = location;
				subNode.parent = parentNode;
				subNode.type = TreeNode.NODE_LOCATION;
				nodes.addItem(subNode);
			} else {
				parentNode.children.addItem(childNode);
                childNode.parent = parentNode;
			}
			saveNode(subNode ? subNode : childNode as TreeNode);
		}

		public function saveNode(node : TreeNode) : void {
			service.addEventListener(AdminServiceEvent.NODE_SAVED, onNodeSaved);

            var locationId : int = 0;
            if (node.location) {
                locationId = node.location.id;
            }
            var moduleId : int = 0;
            if (node.module) {
                moduleId = node.module.id;
                try {
                    locationId = (node.parent as TreeNode).location.id;
                } catch (e:Error) {

                }
            }
            var channelId : int = 0;
            if (node.channel) {
                channelId = node.channel.id;
                try {
                moduleId = (node.parent as TreeNode).module.id;
                locationId = ((node.parent as TreeNode).parent as TreeNode).location.id;
                } catch (e:Error) {

                }
            }
            nodeToSave = node;
			service.saveTreeNode(node.id,
					node.parent ? node.parent.id : 0,
					locationId,
					moduleId,
					channelId,
					node.state,
					node.name,
					node.type);
		}

		private function onNodeSaved(serviceEvent : AdminServiceEvent) : void {
			service.removeEventListener(AdminServiceEvent.NODE_SAVED, onNodeSaved);
            nodeToSave.id = serviceEvent.newId;
		}

		private function findChannelNodeIndex(children : ArrayCollection, channel : Channel) : int {
			for (var i : uint = 0; i < children.length; i++) {
				var node : TreeNode = children.getItemAt(i) as TreeNode;
				if (node.channel == channel) {
					return i;
				}
			}
			return -1;
		}


	}
}
