package com.incheck.ng.dao.hibernate;

import org.springframework.stereotype.Repository;

import com.incheck.ng.dao.ChannelDao;
import com.incheck.ng.model.Channel;

@Repository(value="channelDao")
public class ChannelDaoHibernate extends GenericDaoHibernate<Channel, Long> implements ChannelDao {

    public ChannelDaoHibernate() {
        super(Channel.class);
    }
}
