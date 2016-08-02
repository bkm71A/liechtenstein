package com.inchecktech.dpm.web.rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.inchecktech.dpm.beans.TreeNode;
import com.inchecktech.dpm.network.parser.DamMessage;
import com.inchecktech.dpm.network.parser.IncomingData;
import com.inchecktech.dpm.network.parser.JSONConverter;
import com.inchecktech.dpm.persistence.PersistTreeNode;
import com.inchecktech.dpm.utils.Logger;

@Path("/data")
public class RestfulService {
    private static Logger logger = new Logger(RestfulService.class);

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes({MediaType.APPLICATION_JSON, MediaType.TEXT_PLAIN}) // APPLICATION_JSON
    public String saveData(String jsonDataMessageContent) {
        DamMessage damMessage = JSONConverter.fromJson(jsonDataMessageContent);
        if(damMessage instanceof IncomingData){
            logger.info("RestfulService IncomingData received :" + damMessage);
        } else {
            logger.warn("RestfulService Message is not of type IncomingData !!!, class = " + damMessage.getClass().getName());
        }
        return "OK+";
    }

    @Path("/tree")
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes({MediaType.APPLICATION_JSON, MediaType.TEXT_PLAIN}) // APPLICATION_JSON
    public String getTree() {
        List<TreeNode> roots = buildTree(PersistTreeNode.getTreeNode());
        return JSONConverter.toJson(roots);
    }

    private List<TreeNode> buildTree(List<TreeNode> nodes) {
        List<TreeNode> roots = new ArrayList<TreeNode>();
        Map<Integer, TreeNode> nodeMap = new HashMap<Integer, TreeNode>();
        for (TreeNode node : nodes) {
            nodeMap.put(node.getTreenodeId(), node);
        }
        for (TreeNode node : nodes) {
            if (node.getParentId() == 0) {
                roots.add(node);
            } else {
                TreeNode parent = nodeMap.get(node.getParentId());
                if (parent != null) {
                    parent.addChild(node);
                } else {
                    logger.warn(String.format("Broken tree hierarchy node id=%d; parent id=%d", node.getTreenodeId(), node.getParentId()));
                }
            }
        }
        return roots;
    }
}
