package com.inchecktech.dpm.beans;

import com.inchecktech.dpm.persistence.PersistTreeNode;
import com.inchecktech.dpm.utils.Logger;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ICNodeFactory {
	private static StringBuilder strbased = new StringBuilder();
	private ArrayList<ICNode> nodeList = new ArrayList<ICNode>();
	private HashMap<Integer, ICNode> nodeMapFLAT = new HashMap<Integer, ICNode>();
	private static final Logger logger = new Logger(ICNodeFactory.class);

	private void buildList() {

		nodeList = new ArrayList<ICNode>();
		nodeMapFLAT = new HashMap<Integer, ICNode>();
		strbased = new StringBuilder();

		Map<Integer, ICNode> map = new HashMap<Integer, ICNode>();
		List<TreeNode> nodes = PersistTreeNode.getTreeNode();
		for (TreeNode dNode : nodes) {
			ICNode pNode = null;

			if (0 != dNode.getParentId()) {
				pNode = map.get(dNode.getParentId());
				if (null == pNode) {

					pNode = new ICNode(dNode.getParentId());
					pNode.setName(dNode.getName());
					pNode.setState(dNode.getStatus());
					pNode.setChannelid(dNode.getChannelId());
					pNode.setType(dNode.getTreenodeType());
					pNode.setDesc(dNode.getDescription());
                    pNode.setIncomingDataTimestamp(dNode.getIncomingDataTimestamp());
					map.put(dNode.getParentId(), pNode);

				}
			}

			ICNode cNode = map.get(dNode.getTreenodeId());
			if (null == cNode) {
				cNode = new ICNode(dNode.getTreenodeId());
			}
			cNode.setName(dNode.getName());
			cNode.setState(dNode.getStatus());
			cNode.setChannelid(dNode.getChannelId());
			cNode.setType(dNode.getTreenodeType());
			cNode.setDesc(dNode.getDescription());
			cNode.setIncomingDataTimestamp(dNode.getIncomingDataTimestamp());
			
			PersistTreeNode.updateICNodeChannelTypeAndMeasureType(cNode);

			map.put(dNode.getTreenodeId(), cNode);
			nodeMapFLAT.put(dNode.getChannelId(), cNode);

			if (0 != dNode.getParentId()) {
				pNode.addChild(cNode);
			} else {
				nodeList.add(cNode);
			}
			cNode.setParent(pNode);

		}

		if (null != nodeList) {
			for (ICNode node : nodeList) {
				walk(node, 0);
			}
		}
	}
	
	
	public void updateNode(ICNode n) {
		try {
			ICNode pnode = n.getParent();
			int pid = 0;
			if (pnode != null) {
				pid = pnode.getId();
			}

			PersistTreeNode.updateNode(pid, 0, 0, n.getChannelid(), n.getState(), n
					.getName(), n.getDesc(), n.getType(), n.getId());

		} catch (Throwable e) {
			logger
					.error("An error occured while trying to update node:" + n,
							e);
		}

	}

	public void createNode(ICNode n) {

		try {
			ICNode pnode = n.getParent();
			int pid = 0;
			if (pnode != null) {
				pid = pnode.getId();
			}

			PersistTreeNode.createNode(pid, 0, 0, n.getChannelid(), n.getState(), n.getName(), n.getDesc(), n.getType());
			

		} catch (Throwable e) {
			logger
			.error("An error occured while trying to create node:" + n,
					e);

		}

	}

	// TODO need to make a descision here if the child nodes should go up level
	// or delete them
	public void deleteNode(ICNode n) {
			logger.error("NOT IMPLEMENTED YET");
	}

	public ArrayList<ICNode> getNodeList() {
		buildList();
		return nodeList;
	}

	public HashMap<Integer, ICNode> getFlatNodeMap() {
		buildList();
		return nodeMapFLAT;
	}

	private static void walk(ICNode node, int level) {

		for (int i = 0; i < level; i++) {
			logger.debug("  ");
			strbased.append("  ");

		}
		logger.debug(node.getName());
		strbased.append(node.getName());
		if (node.children.size() > 0) {

			for (ICNode b : node.children) {
				level++;
				walk(b, level);
				level--;
			}
		}
	}

	public static String getStringBasedTree() {
		return strbased.toString();
	}

}