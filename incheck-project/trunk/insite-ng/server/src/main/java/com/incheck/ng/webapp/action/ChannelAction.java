package com.incheck.ng.webapp.action;

import com.opensymphony.xwork2.Preparable;
import com.incheck.ng.service.GenericManager;
import com.incheck.ng.model.Channel;
import com.incheck.ng.webapp.action.BaseAction;

import java.util.List;

public class ChannelAction extends BaseAction implements Preparable {
    private static final long serialVersionUID = -4012455516809772961L;
    private GenericManager<Channel, Long> channelManager;
    private List<Channel> channels;
    private Channel channel;
    private Long id;

    public void setChannelManager(GenericManager<Channel, Long> channelManager) {
        this.channelManager = channelManager;
    }

    public List<Channel> getChannels() {
        return channels;
    }

    /**
     * Grab the entity from the database before populating with request parameters
     */
    public void prepare() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            // prevent failures on new
            String channelId = getRequest().getParameter("channel.id");
            if (channelId != null && !channelId.equals("")) {
                channel = channelManager.get(new Long(channelId));
            }
        }
    }

    public String list() {
        channels = channelManager.getAll();
        return SUCCESS;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Channel getChannel() {
        return channel;
    }

    public void setChannel(Channel channel) {
        this.channel = channel;
    }

    public String delete() {
        channelManager.remove(channel.getId());
        saveMessage(getText("channel.deleted"));

        return SUCCESS;
    }

    public String edit() {
        if (id != null) {
            channel = channelManager.get(id);
        } else {
            channel = new Channel();
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

        boolean isNew = (channel.getId() == null);

        channelManager.save(channel);

        String key = (isNew) ? "channel.added" : "channel.updated";
        saveMessage(getText(key));

        if (!isNew) {
            return INPUT;
        } else {
            return SUCCESS;
        }
    }
}