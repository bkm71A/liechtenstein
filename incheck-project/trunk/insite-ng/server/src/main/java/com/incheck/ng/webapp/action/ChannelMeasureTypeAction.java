package com.incheck.ng.webapp.action;

import java.util.List;

import com.incheck.ng.model.ChannelMeasureType;
import com.incheck.ng.service.GenericManager;
import com.opensymphony.xwork2.Preparable;

public class ChannelMeasureTypeAction extends BaseAction implements Preparable {
    private static final long serialVersionUID = 3982967780869586765L;
    private GenericManager<ChannelMeasureType, Long> channelMeasureTypeManager;
    private List<ChannelMeasureType> channelMeasureTypes;
    private ChannelMeasureType channelMeasureType;
    private Long id;

    public void setChannelMeasureTypeManager(GenericManager<ChannelMeasureType, Long> channelMeasureTypeManager) {
        this.channelMeasureTypeManager = channelMeasureTypeManager;
    }

    public List<ChannelMeasureType> getChannelMeasureTypes() {
        return channelMeasureTypes;
    }

    /**
     * Grab the entity from the database before populating with request
     * parameters
     */
    public void prepare() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            // prevent failures on new
            String channelMeasureTypeId = getRequest().getParameter("channelMeasureType.id");
            if (channelMeasureTypeId != null && !channelMeasureTypeId.equals("")) {
                channelMeasureType = channelMeasureTypeManager.get(new Long(channelMeasureTypeId));
            }
        }
    }

    public String list() {
        channelMeasureTypes = channelMeasureTypeManager.getAll();
        return SUCCESS;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ChannelMeasureType getChannelMeasureType() {
        return channelMeasureType;
    }

    public void setChannelMeasureType(ChannelMeasureType channelMeasureType) {
        this.channelMeasureType = channelMeasureType;
    }

    public String delete() {
        channelMeasureTypeManager.remove(channelMeasureType.getId());
        saveMessage(getText("channelMeasureType.deleted"));

        return SUCCESS;
    }

    public String edit() {
        if (id != null) {
            channelMeasureType = channelMeasureTypeManager.get(id);
        } else {
            channelMeasureType = new ChannelMeasureType();
        }

        return SUCCESS;
    }

    public String save() throws Exception {
        if (cancel != null) {
            return "cancel";
        }

        if (delete != null) {
            return delete();
        }

        boolean isNew = (channelMeasureType.getId() == null);

        channelMeasureTypeManager.save(channelMeasureType);

        String key = (isNew) ? "channelMeasureType.added" : "channelMeasureType.updated";
        saveMessage(getText(key));

        if (!isNew) {
            return INPUT;
        } else {
            return SUCCESS;
        }
    }
}